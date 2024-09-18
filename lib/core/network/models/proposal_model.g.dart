// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proposal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProposalModel _$ProposalModelFromJson(Map<String, dynamic> json) =>
    ProposalModel(
      id: json['docId'] as String,
      dao: json['dao'] == null
          ? null
          : DaoData.fromJson(json['dao'] as Map<String, dynamic>),
      commitment: (json['details_timeShareX100_i'] as num?)?.toInt(),
      title: json['details_title_s'] as String?,
      unity: (json['details_ballotAlignment_i'] as num?)?.toInt(),
      quorum: (json['details_ballotQuorum_i'] as num?)?.toInt(),
      expiration: json['ballot_expiration_t'] == null
          ? null
          : DateTime.parse(json['ballot_expiration_t'] as String),
      creator: json['creator'] == null
          ? null
          : ProfileData.fromJson(json['creator'] as Map<String, dynamic>),
      votes: (json['vote'] as List<dynamic>?)
          ?.map((e) => VoteModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProposalModelToJson(ProposalModel instance) =>
    <String, dynamic>{
      'docId': instance.id,
      'dao': instance.dao,
      'details_timeShareX100_i': instance.commitment,
      'details_title_s': instance.title,
      'details_ballotAlignment_i': instance.unity,
      'details_ballotQuorum_i': instance.quorum,
      'ballot_expiration_t': instance.expiration?.toIso8601String(),
      'creator': instance.creator,
      'vote': instance.votes,
    };
