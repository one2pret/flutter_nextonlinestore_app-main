part of 'shipping_bloc.dart';

@freezed
sealed class ShippingState with _$ShippingState {
  const factory ShippingState.initial() = _Initial;
  const factory ShippingState.loading() = _Loading;
  const factory ShippingState.loaded(ShippingRateData data) = _Loaded;
  const factory ShippingState.error(String message) = _Error;
}
