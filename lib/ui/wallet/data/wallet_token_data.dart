import 'package:hypha_wallet/core/firebase/firebase_token_data.dart';

class WalletTokenData extends FirebaseTokenData {
  final double? userOwnedAmount;
  final bool selected;

  const WalletTokenData({
    required this.selected,
    this.userOwnedAmount,
    required super.network,
    required super.image,
    required super.name,
    required super.contract,
    required super.symbol,
    required super.precision,
  });

  String get ownedAmountAndSymbol => '${userOwnedAmount?.toString() ?? '0'} $symbol';

  WalletTokenData withUserOwnedAmount(double userOwnedAmount) {
    return WalletTokenData(
      selected: selected,
      network: network,
      image: image,
      name: name,
      contract: contract,
      symbol: symbol,
      userOwnedAmount: userOwnedAmount,
      precision: precision,
    );
  }
}
