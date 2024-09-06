import 'package:hypha_wallet/core/error_handler/model/hypha_error.dart';
import 'package:hypha_wallet/core/network/api/services/graphql_service.dart';
import 'package:hypha_wallet/core/network/models/user_profile_data.dart';
import 'package:hypha_wallet/ui/architecture/result/result.dart';

class ProposalService {
  final GraphQLService _graphQLService;

  const ProposalService(this._graphQLService);

  Future<Result<Map<String, dynamic>, HyphaError>> getProposals(UserProfileData user, int daoId) async {
    final String query = '{"query":"query Proposals(\$docId: String!) { queryDao(filter: { docId: { eq: \$docId } }) { details_daoName_n proposal { docId ... on Poll { details_title_s details_ballotAlignment_i details_ballotQuorum_i ballot_expiration_t creator } ... on Budget { details_title_s details_ballotAlignment_i details_ballotQuorum_i ballot_expiration_t creator } ... on Queststart { details_title_s details_ballotAlignment_i details_ballotQuorum_i ballot_expiration_t creator } ... on Questcomplet { details_title_s details_ballotAlignment_i details_ballotQuorum_i ballot_expiration_t creator } ... on Policy { details_title_s details_ballotAlignment_i details_ballotQuorum_i ballot_expiration_t creator } ... on Circle { details_title_s details_ballotAlignment_i details_ballotQuorum_i ballot_expiration_t creator } ... on Payout { details_title_s details_ballotAlignment_i details_ballotQuorum_i ballot_expiration_t creator } ... on Assignment { details_timeShareX100_i details_title_s details_ballotAlignment_i details_ballotQuorum_i ballot_expiration_t creator } ... on Assignbadge { details_title_s details_ballotAlignment_i details_ballotQuorum_i ballot_expiration_t creator } ... on Role { details_title_s details_ballotAlignment_i details_ballotQuorum_i ballot_expiration_t creator } ... on Badge { details_title_s details_ballotAlignment_i details_ballotQuorum_i ballot_expiration_t creator } ... on Suspend { details_title_s details_ballotAlignment_i details_ballotQuorum_i ballot_expiration_t creator } ... on Edit { details_timeShareX100_i original { ... on Assignbadge { details_title_s } ... on Assignment { details_title_s } } details_ballotAlignment_i details_ballotQuorum_i ballot_expiration_t creator } ... on Votable { vote { ... on Vote { vote_voter_n vote_vote_s } } } } } }","variables":{"docId":"$daoId"}}';

    return _graphQLService.graphQLQuery(network: user.network, query: query);
  }
  Future<Result<Map<String, dynamic>, HyphaError>> getProposalDetails(
      String proposalId, UserProfileData user) async {
    final String query =
        '{"query":"query proposalDetails(\$docId: String!) { getDocument(docId: \$docId) {__typename docId creator createdDate ... on Votable {pass: voteAggregate(filter: { vote_vote_s: { regexp: \\"/.*pass*./\\" } }) {count} fail: voteAggregate(filter: { vote_vote_s: { regexp: \\"/.*fail*./\\" } }) {count} vote { ... on Vote { vote_voter_n vote_vote_s } }  } ... on Edit {details_title_s details_description_s details_periodCount_i details_deferredPercX100_i ballot_expiration_t dao {settings {settings_daoTitle_s}} details_ballotAlignment_i details_ballotQuorum_i} ... on Queststart {details_title_s details_description_s details_periodCount_i details_deferredPercX100_i start {details_startTime_t} ballot_expiration_t dao {settings {settings_daoTitle_s}} details_ballotAlignment_i details_ballotQuorum_i details_pegAmount_a details_voiceAmount_a details_rewardAmount_a} ... on Questcomple {details_title_s details_description_s ballot_expiration_t dao {settings {settings_daoTitle_s}} details_pegAmount_a details_voiceAmount_a details_rewardAmount_a} ... on Policy {details_title_s details_description_s details_periodCount_i details_deferredPercX100_i ballot_expiration_t dao {settings {settings_daoTitle_s}} details_ballotAlignment_i details_ballotQuorum_i details_pegAmount_a details_voiceAmount_a details_rewardAmount_a} ... on Payout {details_title_s details_description_s details_periodCount_i details_deferredPercX100_i start {details_startTime_t} ballot_expiration_t dao {settings {settings_daoTitle_s}} details_ballotAlignment_i details_ballotQuorum_i details_pegAmount_a details_voiceAmount_a details_rewardAmount_a} ... on Badge {details_title_s details_description_s details_periodCount_i ballot_expiration_t dao {settings {settings_daoTitle_s}} details_ballotAlignment_i details_ballotQuorum_i} ... on Poll {details_title_s details_description_s ballot_expiration_t dao {settings {settings_daoTitle_s}} details_ballotAlignment_i details_ballotQuorum_i} ... on Budget {details_title_s details_description_s details_deferredPercX100_i ballot_expiration_t dao {settings {settings_daoTitle_s}} details_ballotAlignment_i details_ballotQuorum_i details_pegAmount_a details_voiceAmount_a details_rewardAmount_a} ... on Assignment {details_title_s details_description_s details_periodCount_i details_deferredPercX100_i start {details_startTime_t} details_rewardSalaryPerPeriod_a details_voiceSalaryPerPeriod_a details_pegSalaryPerPeriod_a ballot_expiration_t dao {settings {settings_daoTitle_s}} details_timeShareX100_i details_ballotAlignment_i details_ballotQuorum_i} } }", "variables":{"docId":"$proposalId"}}';
    return _graphQLService.graphQLQuery(network: user.network, query: query);
  }

}