import 'package:hypha_wallet/core/error_handler/model/hypha_error.dart';
import 'package:hypha_wallet/core/firebase/firebase_database_service.dart';
import 'package:hypha_wallet/core/firebase/firebase_token_data.dart';
import 'package:hypha_wallet/core/network/api/services/token_service.dart';
import 'package:hypha_wallet/core/network/models/token_value.dart';
import 'package:hypha_wallet/core/shared_preferences/hypha_shared_prefs.dart';
import 'package:hypha_wallet/ui/architecture/result/result.dart';
import 'package:hypha_wallet/ui/wallet/data/wallet_token_data.dart';

class GetUserTokensUseCase {
  final FirebaseDatabaseService _database;
  final HyphaSharedPrefs _appSharedPrefs;
  final TokenService _tokenService;

  GetUserTokensUseCase(this._database, this._appSharedPrefs, this._tokenService);

  Future<Stream<List<WalletTokenData>>> run() async {
    final user = await _appSharedPrefs.getUserProfileData();
    final List<FirebaseTokenData> allTokens = await _database.getAllTokens();
    final Stream<List<String>> userTokensLive = _database.getUserTokensLive(accountName: user!.accountName);

    final Stream<Iterable<Future<WalletTokenData>>> mappedData = userTokensLive.map((List<String> userTokens) {
      return allTokens.where((element) => userTokens.contains(element.id)).map((e) async {
        final Result<TokenValue, HyphaError> tokenBalance = await _tokenService.getTokenBalance(
          userAccount: user.accountName,
          tokenContract: e.contract,
          symbol: e.symbol,
        );
        return WalletTokenData(
          userOwnedAmount: tokenBalance.asValue?.value.amount,
          selected: true,
          image: e.image,
          name: e.name,
          contract: e.contract,
          symbol: e.symbol,
          id: e.id,
        );
      });
    });

    final Stream<List<WalletTokenData>> tokens =
        mappedData.asyncMap((Iterable<Future<WalletTokenData>> event) => Future.wait(event));
    return tokens;
  }
}
