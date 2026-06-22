part of 'register_bloc.dart';

@freezed
sealed class RegisterEvent with _$RegisterEvent {
  const factory RegisterEvent.register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) = _Register;
}
