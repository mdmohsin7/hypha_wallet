part of 'di_setup.dart';

void _registerBlocsModule() {
  /// Global Blocs
  _registerFactory(
      () => AuthenticationBloc(_getIt<AuthRepository>(), _getIt<HyphaSharedPrefs>(), _getIt<SecureStorageService>()));
  _registerFactory(() => DeeplinkBloc());
  _registerFactory(() => ErrorHandlerBloc(_getIt<ErrorHandlerManager>()));
  _registerFactory(() => SettingsBloc(_getIt<HyphaSharedPrefs>()));

  /// Views Blocs
  _registerFactory(() => HomeBloc(_getIt<ParseQRCodeUseCase>()));
  _registerFactory(() => ImportAccountBloc(
        _getIt<GenerateKeyFromRecoveryWordsUseCase>(),
        _getIt<GenerateKeyFromSeedsPassportWordsUseCase>(),
        _getIt<ValidateKeyUseCase>(),
        _getIt<ErrorHandlerManager>(),
        _getIt<FindAccountsUseCase>(),
        _getIt<AuthRepository>(),
      ));
  _registerFactory(() => BottomNavigationBloc());
  _registerFactory(() => TransactionDetailsBloc(_getIt<SignTransactionUseCase>()));
  _registerFactoryWithParams<CreateAccountBloc, XFile?, String>(
    (image, userName) => CreateAccountBloc(
      _getIt<CheckAccountAvailabilityUseCase>(),
      image,
      userName,
    ),
  );

  _registerFactoryWithParams<EditAccountBloc, XFile?, String>(
    (image, userName) => EditAccountBloc(
      _getIt<CheckAccountAvailabilityUseCase>(),
      _getIt<CreateAccountUseCase>(),
      _getIt<ErrorHandlerManager>(),
      _getIt<CryptoAuthService>(),
      image,
      userName,
    ),
  );
}
