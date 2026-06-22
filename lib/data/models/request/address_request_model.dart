import 'dart:convert';

class AddressRequestModel {
  final String recipientName;
  final String phone;
  final String address;
  final String? detail;
  final String province;
  final String? provinceId;
  final String city;
  final String? cityId;
  final String? district;
  final String? districtId;
  final String postalCode;
  final String? latitude;
  final String? longitude;
  final String? label;
  final bool? isDefault;

  AddressRequestModel({
    required this.recipientName,
    required this.phone,
    required this.address,
    this.detail,
    required this.province,
    this.provinceId,
    required this.city,
    this.cityId,
    this.district,
    this.districtId,
    required this.postalCode,
    this.latitude,
    this.longitude,
    this.label,
    this.isDefault,
  });

  Map<String, dynamic> toMap() => {
        'recipientName': recipientName,
        'phone': phone,
        'address': address,
        'detail': detail,
        'province': province,
        'provinceId': provinceId,
        'city': city,
        'cityId': cityId,
        'district': district,
        'districtId': districtId,
        'postalCode': postalCode,
        'latitude': latitude,
        'longitude': longitude,
        'label': label,
        'isDefault': isDefault ?? false,
      };

  String toJson() => jsonEncode(toMap());
}
