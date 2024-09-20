import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hypha_wallet/core/error_handler/error_handler_manager.dart';
import 'package:hypha_wallet/core/error_handler/model/hypha_error.dart';
import 'package:hypha_wallet/core/network/models/dao_data_model.dart';
import 'package:hypha_wallet/core/network/models/proposal_model.dart';
import 'package:hypha_wallet/ui/architecture/interactor/page_states.dart';
import 'package:hypha_wallet/ui/architecture/result/result.dart';
import 'package:hypha_wallet/ui/profile/interactor/profile_data.dart';
import 'package:hypha_wallet/ui/profile/usecases/fetch_profile_use_case.dart';
import 'package:hypha_wallet/ui/proposals/filter/interactor/filter_status.dart';
import 'package:hypha_wallet/ui/proposals/list/usecases/get_proposals_use_case.dart';

part 'proposals_bloc.freezed.dart';
part 'proposals_event.dart';
part 'proposals_state.dart';

class ProposalsBloc extends Bloc<ProposalsEvent, ProposalsState> {
  final GetProposalsUseCase _getProposalsUseCase;
  final FetchProfileUseCase _fetchProfileUseCase;
  final ErrorHandlerManager _errorHandlerManager;

  ProposalsBloc(this._getProposalsUseCase, this._fetchProfileUseCase, this._errorHandlerManager) : super(const ProposalsState()) {
    on<_Initial>(_initial);
  }

  FilterStatus filterStatus = FilterStatus.active;

  Future<void> _initial(_Initial event, Emitter<ProposalsState> emit) async {
    if (!event.refresh) {
      emit(state.copyWith(pageState: PageState.loading));
      filterStatus = event.filterStatus;
    }

    if (event.daos != null) {
      await _fetchAndEmitProposals(emit, event.daos!, filterStatus);
      return;
    }

    final Result<ProfileData, HyphaError> profileResult = await _fetchProfileUseCase.run();

    if (profileResult.isValue && profileResult.asValue!.value.daos.isNotEmpty) {
      await _fetchAndEmitProposals(emit, profileResult.asValue!.value.daos, filterStatus);
    } else {
      final HyphaError error = profileResult.isError ? profileResult.asError!.error : HyphaError.api('Failed to retrieve DAOs');
      await _errorHandlerManager.handlerError(error);
      emit(state.copyWith(pageState: PageState.failure));
    }
  }

  Future<void> _fetchAndEmitProposals(Emitter<ProposalsState> emit, List<DaoData> daos, FilterStatus filterStatus) async {
    final Result<List<ProposalModel>, HyphaError> proposalsResult = await _getProposalsUseCase.run(daos, filterStatus);

    if (proposalsResult.isValue) {
      emit(state.copyWith(pageState: PageState.success, proposals: proposalsResult.asValue!.value));
    } else {
      await _errorHandlerManager.handlerError(proposalsResult.asError!.error);
      emit(state.copyWith(pageState: PageState.failure));
    }
  }
}
