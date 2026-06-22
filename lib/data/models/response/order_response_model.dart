import 'dart:convert';

class Order {
  final int? id;
  final String? orderNumber;
  final int? userId;
  final int? addressId;
  final String? subtotal;
  final String? shippingCost;
  final String? total;
  final String? status;
  final String? paymentStatus;
  final String? paymentUrl;
  final String? invoiceId;
  final String? courierName;
  final String? courierCompany;
  final String? courierType;
  final String? notes;
  final String? shippingName;
  final String? shippingAddress;
  final String? willExpiredAt;
  final String? expiredAt;
  final String? paidAt;
  final String? createdAt;
  final String? updatedAt;
  final List<OrderItem>? items;
  final OrderShipping? shipping;

  Order({
    this.id,
    this.orderNumber,
    this.userId,
    this.addressId,
    this.subtotal,
    this.shippingCost,
    this.total,
    this.status,
    this.paymentStatus,
    this.paymentUrl,
    this.invoiceId,
    this.courierName,
    this.courierCompany,
    this.courierType,
    this.notes,
    this.shippingName,
    this.shippingAddress,
    this.willExpiredAt,
    this.expiredAt,
    this.paidAt,
    this.createdAt,
    this.updatedAt,
    this.items,
    this.shipping,
  });

  factory Order.fromMap(Map<String, dynamic> map) => Order(
        id: map['id']?.toInt(),
        orderNumber: map['orderNumber'],
        userId: map['userId']?.toInt(),
        addressId: map['addressId']?.toInt(),
        subtotal: map['subtotal']?.toString(),
        shippingCost: map['shippingCost']?.toString(),
        total: map['total']?.toString(),
        status: map['status'],
        paymentStatus: map['paymentStatus'],
        paymentUrl: map['paymentUrl'],
        invoiceId: map['invoiceId'],
        courierName: map['courierName'],
        courierCompany: map['courierCompany'],
        courierType: map['courierType'],
        notes: map['notes'],
        shippingName: map['shippingName'],
        shippingAddress: map['shippingAddress'],
        willExpiredAt: map['willExpiredAt'],
        expiredAt: map['expiredAt'],
        paidAt: map['paidAt'],
        createdAt: map['createdAt'],
        updatedAt: map['updatedAt'],
        items: map['items'] != null
            ? List<OrderItem>.from(
                map['items'].map((x) => OrderItem.fromMap(x)))
            : null,
        shipping: map['shipping'] != null
            ? OrderShipping.fromMap(map['shipping'])
            : null,
      );

  String get statusLabel => switch (status) {
        'waiting_payment' => 'Menunggu Pembayaran',
        'packing' => 'Diproses',
        'shipping' => 'Dikirim',
        'delivered' => 'Selesai',
        'cancelled' => 'Dibatalkan',
        'expired' => 'Kadaluarsa',
        _ => status ?? '',
      };

  int get totalItemCount =>
      items?.fold<int>(0, (sum, i) => sum + (i.quantity ?? 0)) ?? 0;
}

class OrderItem {
  final int? id;
  final String? productName;
  final String? productImage;
  final String? price;
  final int? quantity;
  final String? subtotal;

  OrderItem({
    this.id,
    this.productName,
    this.productImage,
    this.price,
    this.quantity,
    this.subtotal,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) => OrderItem(
        id: map['id']?.toInt(),
        productName: map['productName'],
        productImage: map['productImage'],
        price: map['price']?.toString(),
        quantity: map['quantity']?.toInt(),
        subtotal: map['subtotal']?.toString(),
      );
}

class OrderShipping {
  final String? courierName;
  final String? trackingId;
  final String? waybillId;
  final List<ShippingHistory>? histories;

  OrderShipping({
    this.courierName,
    this.trackingId,
    this.waybillId,
    this.histories,
  });

  factory OrderShipping.fromMap(Map<String, dynamic> map) => OrderShipping(
        courierName: map['courierName'],
        trackingId: map['trackingId'],
        waybillId: map['waybillId'],
        histories: map['histories'] != null
            ? List<ShippingHistory>.from(
                map['histories'].map((x) => ShippingHistory.fromMap(x)))
            : null,
      );
}

class ShippingHistory {
  final String? status;
  final String? note;
  final String? createdAt;

  ShippingHistory({this.status, this.note, this.createdAt});

  factory ShippingHistory.fromMap(Map<String, dynamic> map) =>
      ShippingHistory(
        status: map['status'],
        note: map['note'],
        createdAt: map['createdAt'],
      );
}

class OrderResponseModel {
  final bool? success;
  final List<Order>? data;
  OrderResponseModel({this.success, this.data});

  factory OrderResponseModel.fromJson(String source) {
    final map = jsonDecode(source);
    return OrderResponseModel(
      success: map['success'],
      data: map['data'] != null
          ? List<Order>.from(map['data'].map((x) => Order.fromMap(x)))
          : null,
    );
  }
}

class OrderDetailResponseModel {
  final bool? success;
  final Order? data;
  final String? paymentUrl;

  OrderDetailResponseModel({this.success, this.data, this.paymentUrl});

  factory OrderDetailResponseModel.fromJson(String source) {
    final map = jsonDecode(source);
    return OrderDetailResponseModel(
      success: map['success'],
      data: map['data'] != null ? Order.fromMap(map['data']) : null,
      paymentUrl: map['data']?['paymentUrl'],
    );
  }
}

class OrderCreateResponseModel {
  final bool? success;
  final Order? data;
  final String? paymentUrl;

  OrderCreateResponseModel({this.success, this.data, this.paymentUrl});

  factory OrderCreateResponseModel.fromJson(String source) {
    final map = jsonDecode(source);
    final data = map['data'];
    return OrderCreateResponseModel(
      success: map['success'],
      data: data != null ? Order.fromMap(data) : null,
      paymentUrl: map['paymentUrl'] ?? data?['paymentUrl'],
    );
  }
}
