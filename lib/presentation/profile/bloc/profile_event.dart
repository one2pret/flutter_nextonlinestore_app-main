part of 'profile_bloc.dart';

@freezed
sealed class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.getProfile() = _GetProfile;
  const factory ProfileEvent.updateProfile({
    required String name,
    required String phone,
  }) = _UpdateProfile;
  const factory ProfileEvent.logout() = _Logout;
}
