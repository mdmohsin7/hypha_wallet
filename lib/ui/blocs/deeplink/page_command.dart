part of 'deeplink_bloc.dart';

@freezed
class PageCommand with _$PageCommand {
  const factory PageCommand.navigateToCreateAccount() = _NavigateToCreateAccount;
}
