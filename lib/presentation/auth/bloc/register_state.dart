part of 'register_bloc.dart';

@freezed
sealed class RegisterState with _$RegisterState {
  const factory RegisterState.initial() = _Initial;
  const factory RegisterState.loading() = _Loading;
  const factory RegisterState.success(String message) = _Success;
  const factory RegisterState.error(String message) = _Error;
}
