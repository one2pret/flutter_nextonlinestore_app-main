import 'dart:convert';

class OrderRequestModel {
  final int addressId;
  final String courierName;
  final String courierCompany;
  final String courierType;
  final int courierPrice;
  final String? notes;

  OrderRequestModel({
    required this.addressId,
    required this.courierName,
    required this.courierCompany,
    required this.courierType,
    required this.courierPrice,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'addressId': addressId,
      'courierName': courierName,
      'courierCompany': courierCompany,
      'courierType': courierType,
      'courierPrice': courierPrice,
    };
    if (notes != null && notes!.isNotEmpty) map['notes'] = notes;
    return map;
  }

  String toJson() => jsonEncode(toMap());
}
