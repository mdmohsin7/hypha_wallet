import 'dart:async';
import 'package:hypha_wallet/core/error_handler/model/hypha_error.dart';
import 'package:hypha_wallet/core/extension/map_extension.dart';
import 'package:hypha_wallet/core/logging/log_helper.dart';
import 'package:hypha_wallet/core/network/api/services/dao_service.dart';
import 'package:hypha_wallet/core/network/api/services/proposal_service.dart';
import 'package:hypha_wallet/core/network/models/dao_data_model.dart';
import 'package:hypha_wallet/core/network/models/network.dart';
import 'package:hypha_wallet/core/network/models/proposal_details_model.dart';
import 'package:hypha_wallet/core/network/models/proposal_model.dart';
import 'package:hypha_wallet/core/network/models/user_profile_data.dart';
import 'package:hypha_wallet/core/network/repository/profile_repository.dart';
import 'package:hypha_wallet/ui/architecture/result/result.dart';
import 'package:hypha_wallet/ui/profile/interactor/profile_data.dart';
import 'package:hypha_wallet/ui/proposals/filter/interactor/filter_status.dart';
import 'package:hypha_wallet/ui/proposals/list/usecases/get_proposals_use_case_input.dart';

class ProposalRepository {
  final ProposalService _proposalService;
  final ProfileService _profileService;
  final DaoService _daoService;

  ProposalRepository(this._daoService, this._proposalService, this._profileService);

  Future<Result<List<ProposalModel>, HyphaError>> getProposals(UserProfileData user, GetProposalsUseCaseInput input) async {
    final List<Future<Result<Map<String, dynamic>, HyphaError>>> futures = input.daos.map((DaoData dao) {
      return input.filterStatus == FilterStatus.active
          ? _proposalService.getActiveProposals(user, dao.docId, input.first, input.offset)
          : _proposalService.getPastProposals(user, dao.docId, input.first,  input.offset);
    }).toList();

    final List<Result<Map<String, dynamic>, HyphaError>> futureResults = await Future.wait(futures);

    final List<ProposalModel> allProposals = [];

    for (int i = 0; i < futureResults.length; i++) {
      final Result<Map<String, dynamic>, HyphaError> result = futureResults[i];

      if (result.isValue) {
        final Map<String, dynamic> response = result.asValue!.value;

        if (response['errors'] != null) {
          LogHelper.e('GraphQL query failed', error: response['errors']);
          return Result.error(HyphaError.api('GraphQL query failed'));
        }

        try {
          final List<ProposalModel> proposals = await _parseProposalsFromResponse(response, input.daos[i], input.filterStatus);
          allProposals.addAll(proposals);
        } catch (e, stackTrace) {
          LogHelper.e('Error parsing data into proposal model', error: e, stacktrace: stackTrace);
          return Result.error(HyphaError.generic('Error parsing data into proposal model'));
        }
      } else {
        LogHelper.e('GraphQL query failed', error: result.asError!.error);
        return Result.error(result.asError!.error);
      }
    }

    return Result.value(allProposals);
  }

  Future<List<ProposalModel>> _parseProposalsFromResponse(Map<String, dynamic> response, DaoData daoData, FilterStatus filterStatus) async {
    final List<dynamic> proposalsData = response['data']['queryDao'];

    final List<Future<ProposalModel>> proposalFutures = proposalsData.expand((dao) {
      final List<dynamic> proposals = dao[filterStatus == FilterStatus.active ? 'proposal' : 'votable'] as List<dynamic>;

      return proposals.where((dynamic proposal) {
        if (filterStatus == FilterStatus.past) {
          final Map<String, dynamic> proposalMap = Map<String, dynamic>.from(proposal);
          return proposalMap.isValidProposal();
        }

        return true;
      }).map((dynamic proposal) async {
        final Result<ProfileData, HyphaError> creator = await _profileService.getProfile(proposal['creator']);
        proposal['creator'] = null;

        final ProposalModel proposalModel = ProposalModel.fromJson(proposal);
        if (creator.isValue) {
          proposalModel.creator = creator.asValue!.value;
        }
        proposalModel.dao = daoData;

        return proposalModel;
      });
    }).toList();

    return Future.wait(proposalFutures);
  }

  Future<Result<ProposalDetailsModel, HyphaError>> getProposalDetails(String proposalId, UserProfileData user) async {
    final Result<Map<String, dynamic>, HyphaError> result = await _proposalService.getProposalDetails(proposalId, user);

    if (result.isValue) {
      if (result.asValue!.value['errors'] != null) {
        LogHelper.e('GraphQL query failed', error: result.asValue!.value['errors']);
        return Result.error(HyphaError.api('GraphQL query failed'));
      }

      try {
        final Map<String, dynamic> response = result.valueOrCrash;
        final Result<DaoData?, HyphaError> dao= await _daoService.getDaoById(network: Network.telos, daoId:response['data']['getDocument']['dao'][0]['docId'] );
        final Result<ProfileData, HyphaError> creator = await _profileService.getProfile(response['data']['getDocument']['creator']);
        final ProposalDetailsModel proposalDetails = ProposalDetailsModel.fromJson(response['data']['getDocument']);

        if (proposalDetails.votes != null) {
          for (int i = 0; i < proposalDetails.votes!.length; i++) {
            final Result<ProfileData, HyphaError> voterData = await _profileService.getProfile(proposalDetails.votes![i].voter);
            if (voterData.isValue) {
              proposalDetails.votes![i].voterImageUrl = voterData.asValue!.value.avatarUrl;
            }
          }
        }

        proposalDetails.creator=creator.asValue!.value;
        proposalDetails.dao=dao.asValue!.value;
        return Result.value(proposalDetails);
      } catch (e, stackTrace) {
        LogHelper.e('Error parsing data into proposal details model', error: e, stacktrace: stackTrace);
        return Result.error(HyphaError.generic('Error parsing data into details proposal model'));
      }
    } else {
      LogHelper.e('GraphQL query failed', error: result.asError!.error);
      return Result.error(result.asError!.error);
    }
  }
}
