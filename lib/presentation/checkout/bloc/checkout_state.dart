part of 'checkout_bloc.dart';

@freezed
sealed class CheckoutState with _$CheckoutState {
  const factory CheckoutState.initial() = _Initial;
  const factory CheckoutState.loading() = _Loading;
  const factory CheckoutState.success(Order order, String? paymentUrl) =
      _Success;
  const factory CheckoutState.error(String message) = _Error;
}
