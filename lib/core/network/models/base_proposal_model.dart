import 'package:hypha_wallet/core/network/models/dao_data_model.dart';
import 'package:hypha_wallet/core/network/models/vote_model.dart';
import 'package:hypha_wallet/ui/profile/interactor/profile_data.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
abstract class BaseProposalModel {
  @JsonKey(name: 'docId')
  final String id;

  DaoData? dao;

  @JsonKey(name: 'details_timeShareX100_i')
  final int? commitment;

  @JsonKey(name: 'details_title_s')
  final String? title;

  @JsonKey(name: 'details_ballotAlignment_i')
  final int? unity;

  @JsonKey(name: 'details_ballotQuorum_i')
  final int? quorum;

  @JsonKey(name: 'ballot_expiration_t')
  final DateTime? expiration;

  ProfileData? creator;

  @JsonKey(name: 'vote')
  final List<VoteModel>? votes;

  BaseProposalModel({
    required this.id,
    this.dao,
    this.commitment,
    this.title,
    this.unity,
    this.quorum,
    this.expiration,
    this.creator,
    this.votes,
  });
}