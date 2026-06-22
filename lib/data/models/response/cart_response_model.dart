import 'dart:convert';

import 'product_response_model.dart';

class CartResponseModel {
  final bool? success;
  final List<CartItem>? data;

  CartResponseModel({this.success, this.data});

  factory CartResponseModel.fromJson(String source) {
    final map = jsonDecode(source);
    return CartResponseModel(
      success: map['success'],
      data: map['data'] != null
          ? List<CartItem>.from(map['data'].map((x) => CartItem.fromMap(x)))
          : null,
    );
  }
}

class CartItem {
  final int? id;
  final int? userId;
  final int? productId;
  final int? quantity;
  final String? createdAt;
  final String? updatedAt;
  final Product? product;

  CartItem({
    this.id,
    this.userId,
    this.productId,
    this.quantity,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id']?.toInt(),
      userId: map['userId']?.toInt(),
      productId: map['productId']?.toInt(),
      quantity: map['quantity']?.toInt(),
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      product:
          map['product'] != null ? Product.fromMap(map['product']) : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'productId': productId,
        'quantity': quantity,
      };
}
