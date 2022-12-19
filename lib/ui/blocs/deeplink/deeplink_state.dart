part of 'deeplink_bloc.dart';

@freezed
class DeeplinkState with _$DeeplinkState {
  const factory DeeplinkState({
    String? link,
    PageCommand? command,
  }) = _DeeplinkState;
}
