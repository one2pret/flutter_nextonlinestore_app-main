import 'dart:convert';

class AddressResponseModel {
  final bool? success;
  final List<Address>? data;
  AddressResponseModel({this.success, this.data});

  factory AddressResponseModel.fromJson(String source) {
    final map = jsonDecode(source);
    return AddressResponseModel(
      success: map['success'],
      data: map['data'] != null
          ? List<Address>.from(map['data'].map((x) => Address.fromMap(x)))
          : null,
    );
  }
}

class Address {
  final int? id;
  final int? userId;
  final String? recipientName;
  final String? phone;
  final String? address;
  final String? detail;
  final String? province;
  final String? provinceId;
  final String? city;
  final String? cityId;
  final String? district;
  final String? districtId;
  final String? postalCode;
  final String? latitude;
  final String? longitude;
  final String? label;
  final bool? isDefault;
  final String? createdAt;
  final String? updatedAt;

  Address({
    this.id,
    this.userId,
    this.recipientName,
    this.phone,
    this.address,
    this.detail,
    this.province,
    this.provinceId,
    this.city,
    this.cityId,
    this.district,
    this.districtId,
    this.postalCode,
    this.latitude,
    this.longitude,
    this.label,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
  });

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id']?.toInt(),
      userId: map['userId']?.toInt(),
      recipientName: map['recipientName'],
      phone: map['phone'],
      address: map['address'],
      detail: map['detail'],
      province: map['province'],
      provinceId: map['provinceId']?.toString(),
      city: map['city'],
      cityId: map['cityId']?.toString(),
      district: map['district'],
      districtId: map['districtId']?.toString(),
      postalCode: map['postalCode'],
      latitude: map['latitude']?.toString(),
      longitude: map['longitude']?.toString(),
      label: map['label'],
      isDefault: map['isDefault'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  String get fullAddress {
    final parts = <String>[];
    if (address != null && address!.isNotEmpty) parts.add(address!);
    if (detail != null && detail!.isNotEmpty) parts.add(detail!);
    if (district != null && district!.isNotEmpty) parts.add(district!);
    if (city != null && city!.isNotEmpty) parts.add(city!);
    if (province != null && province!.isNotEmpty) parts.add(province!);
    if (postalCode != null && postalCode!.isNotEmpty) parts.add(postalCode!);
    return parts.join(', ');
  }
}
