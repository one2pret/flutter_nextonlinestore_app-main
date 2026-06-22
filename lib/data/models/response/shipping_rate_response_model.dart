import 'dart:convert';

class ShippingRateResponseModel {
  final bool? success;
  final ShippingRateData? data;

  ShippingRateResponseModel({this.success, this.data});

  factory ShippingRateResponseModel.fromJson(String source) {
    final map = jsonDecode(source);
    return ShippingRateResponseModel(
      success: map['success'],
      data: map['data'] != null ? ShippingRateData.fromMap(map['data']) : null,
    );
  }
}

class ShippingRateData {
  final List<ShippingRate>? express;
  final List<ShippingRate>? regular;
  final List<ShippingRate>? economy;

  ShippingRateData({this.express, this.regular, this.economy});

  factory ShippingRateData.fromMap(Map<String, dynamic> map) =>
      ShippingRateData(
        express: _parseList(map['express']),
        regular: _parseList(map['regular']),
        economy: _parseList(map['economy']),
      );

  static List<ShippingRate>? _parseList(dynamic raw) => raw == null
      ? null
      : List<ShippingRate>.from(raw.map((x) => ShippingRate.fromMap(x)));

  List<ShippingRateGroup> get groups {
    final result = <ShippingRateGroup>[];
    if (express != null && express!.isNotEmpty) {
      result.add(
          ShippingRateGroup(label: 'Express (1-2 hari)', rates: express!));
    }
    if (regular != null && regular!.isNotEmpty) {
      result.add(
          ShippingRateGroup(label: 'Regular (2-4 hari)', rates: regular!));
    }
    if (economy != null && economy!.isNotEmpty) {
      result.add(
          ShippingRateGroup(label: 'Ekonomi (4-7 hari)', rates: economy!));
    }
    return result;
  }
}

class ShippingRateGroup {
  final String label;
  final List<ShippingRate> rates;
  ShippingRateGroup({required this.label, required this.rates});
}

class ShippingRate {
  final String? type;
  final String? company;
  final String? courierName;
  final String? courierCode;
  final String? courierServiceName;
  final String? courierServiceCode;
  final int? price;
  final String? duration;
  final String? shipmentDurationRange;

  ShippingRate({
    this.type,
    this.company,
    this.courierName,
    this.courierCode,
    this.courierServiceName,
    this.courierServiceCode,
    this.price,
    this.duration,
    this.shipmentDurationRange,
  });

  factory ShippingRate.fromMap(Map<String, dynamic> map) => ShippingRate(
        type: map['type'],
        company: map['company'],
        courierName: map['courier_name'],
        courierCode: map['courier_code'],
        courierServiceName: map['courier_service_name'],
        courierServiceCode: map['courier_service_code'],
        price: map['price']?.toInt(),
        duration: map['duration'],
        shipmentDurationRange: map['shipment_duration_range'],
      );

  String get displayName =>
      '${courierName ?? ''} ${courierServiceName ?? ''}';
  String get estimateDisplay => shipmentDurationRange ?? duration ?? '-';
}
