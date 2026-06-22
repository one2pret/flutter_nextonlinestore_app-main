part of 'address_bloc.dart';

@freezed
sealed class AddressEvent with _$AddressEvent {
  const factory AddressEvent.getAddresses() = _GetAddresses;
  const factory AddressEvent.createAddress(AddressRequestModel request) =
      _CreateAddress;
  const factory AddressEvent.updateAddress(
      int id, AddressRequestModel request) = _UpdateAddress;
  const factory AddressEvent.deleteAddress(int id) = _DeleteAddress;
  const factory AddressEvent.setDefault(int id) = _SetDefault;
}
