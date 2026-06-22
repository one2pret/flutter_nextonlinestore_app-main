import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../core/constants/variables.dart';
import '../models/request/cart_request_model.dart';
import '../models/response/cart_response_model.dart';
import 'api_helper.dart';
import 'auth_local_datasource.dart';

class CartRemoteDatasource {
  Future<Either<String, CartResponseModel>> getCart() async {
    try {
      final token = await AuthLocalDatasource().getToken();
      final response = await ApiHelper.get(
        Uri.parse('${Variables.baseUrl}/api/cart'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return Right(CartResponseModel.fromJson(response.body));
      }
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Gagal memuat keranjang');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, String>> addToCart(CartRequestModel request) async {
    try {
      final token = await AuthLocalDatasource().getToken();
      final response = await ApiHelper.post(
        Uri.parse('${Variables.baseUrl}/api/cart'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: request.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right('Berhasil ditambahkan ke keranjang');
      }
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Gagal menambahkan ke keranjang');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, String>> updateCartItem(int id, int quantity) async {
    try {
      final token = await AuthLocalDatasource().getToken();
      final response = await ApiHelper.put(
        Uri.parse('${Variables.baseUrl}/api/cart/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'quantity': quantity}),
      );
      if (response.statusCode == 200) {
        return const Right('Keranjang berhasil diperbarui');
      }
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Gagal memperbarui keranjang');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, String>> removeCartItem(int id) async {
    try {
      final token = await AuthLocalDatasource().getToken();
      final response = await ApiHelper.delete(
        Uri.parse('${Variables.baseUrl}/api/cart/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return const Right('Item berhasil dihapus');
      }
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Gagal menghapus item');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }
}
