import 'package:hypha_wallet/core/network/models/proposal_model.dart';

extension ProposalModelTimeFormatting on ProposalModel {
  String formatExpiration() {
    if (expiration == null) return 'Expired';

    final now = DateTime.now();
    final expirationDate = expiration!.toLocal();
    final difference = expirationDate.difference(now);

    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;

    final parts = <String>[];
    if (days > 0) {
      parts.add('$days Day${days > 1 ? 's' : ''}');
    }
    if (hours > 0) {
      parts.add('$hours hour${hours > 1 ? 's' : ''}');
    }
    if (minutes > 0) {
      parts.add('$minutes minute${minutes > 1 ? 's' : ''}');
    }

    return parts.isNotEmpty ? 'Expiring in ${parts.join(', ')}' : 'Expired';
  }
  double quorumToPercent() => quorum==null?0:quorum!*.01;
  double unityToPercent() => unity==null?0:unity!*.01;
}

