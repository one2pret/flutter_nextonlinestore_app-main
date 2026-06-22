part of 'shipping_bloc.dart';

@freezed
sealed class ShippingEvent with _$ShippingEvent {
  const factory ShippingEvent.calculateRates(int addressId) = _CalculateRates;
}
