part of 'profile_bloc.dart';

@freezed
sealed class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = _Initial;
  const factory ProfileState.loading() = _Loading;
  const factory ProfileState.loaded(User user) = _Loaded;
  const factory ProfileState.updated(User user) = _Updated;
  const factory ProfileState.loggedOut() = _LoggedOut;
  const factory ProfileState.error(String message) = _Error;
}
