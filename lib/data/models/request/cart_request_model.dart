import 'dart:convert';

class CartRequestModel {
  final int productId;
  final int quantity;

  CartRequestModel({required this.productId, required this.quantity});

  Map<String, dynamic> toMap() =>
      {'productId': productId, 'quantity': quantity};
  String toJson() => jsonEncode(toMap());
}
