import 'package:hdkey/hdkey.dart';
import 'package:hypha_wallet/core/crypto/eosdart_ecc/src/key.dart';
import 'package:hypha_wallet/core/local/models/auth_data_model.dart';
import 'package:hypha_wallet/core/mnemonic_code/hex.dart';
import 'package:hypha_wallet/core/mnemonic_code/mnemonic_code.dart';

const STRENGTH_FOR_TWELVE_WORDS = 16;

class CryptoAuthService {
  /// Creates a random private key/12 words pair. Used for user auth.
  AuthDataModel createRandomPrivateKeyAndWords() {
    final words = _createRandom12Words();

    return AuthDataModel(_createPrivateKeyFrom12Words(words), words);
  }

  /// Creates a private key/12 words pair. From words
  AuthDataModel createPrivateKeyFromWords(List<String> words) {
    return AuthDataModel(_createPrivateKeyFrom12Words(words), words);
  }

  AuthDataModel privateKeyFromSeedsGlobalPassportWords(List<String> words) {
    return AuthDataModel(createPrivateKeyFrom12WordsBip39(words), words);
  }

  /// Creates a private key from 12 words list
  EOSPrivateKey _createPrivateKeyFrom12Words(List<String> words) {
    assert(words.length == 12);
    return EOSPrivateKey.fromSeed(words.join('-'));
  }

  /// Creates 12 random words Mnemonic.
  List<String> _createRandom12Words() {
    final bytes = randomBytes(STRENGTH_FOR_TWELVE_WORDS);
    return entropyToMnemonic(hexCodec.encode(bytes)).split('-');
  }

  /// Seeds Global Passport compatibility method - creates an EOS key the same
  /// way the SGP does, by first creating an ETH key, then deriving a child key,
  /// then creating an EOS key from the derived key.
  EOSPrivateKey createPrivateKeyFrom12WordsBip39(List<String> words) {
    assert(words.length == 12);
    final mnemonic = words.join(' ');
    // First, we create an ETH derived key - like the passport does
    final ethKey = generateEthDerivedKeyFromSeed(mnemonic);
    // Then we create an EOS key from the ETH derived key
    final eosKey = EOSPrivateKey.fromBuffer(ethKey.privateKey);
    return eosKey;
  }

  /// Helper method to create an ETH key from a mnemonic
  HDKey generateEthDerivedKeyFromSeed(String mnemonic) {
    final HDKey hdkey = HDKey.fromMnemonic(mnemonic);
    const walletHdPath = "m/44'/60'/0'/0/1";
    final HDKey childKey = hdkey.derive(walletHdPath);
    return childKey;
  }
}