import 'dart:convert';

import 'package:dartz/dartz.dart' hide Order;

import '../../core/constants/variables.dart';
import '../models/request/order_request_model.dart';
import '../models/response/order_response_model.dart';
import 'api_helper.dart';
import 'auth_local_datasource.dart';

class OrderRemoteDatasource {
  Future<Map<String, String>> _authHeaders() async {
    final token = await AuthLocalDatasource().getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Either<String, OrderResponseModel>> getOrders({
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (status != null) 'status': status,
      };
      final uri = Uri.parse('${Variables.baseUrl}/api/orders')
          .replace(queryParameters: queryParams);
      final response =
          await ApiHelper.get(uri, headers: await _authHeaders());
      if (response.statusCode == 200) {
        return Right(OrderResponseModel.fromJson(response.body));
      }
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Gagal memuat pesanan');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, OrderCreateResponseModel>> createOrder(
      OrderRequestModel request) async {
    try {
      final response = await ApiHelper.post(
        Uri.parse('${Variables.baseUrl}/api/orders'),
        headers: await _authHeaders(),
        body: request.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(OrderCreateResponseModel.fromJson(response.body));
      }
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Gagal membuat pesanan');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, Order>> getOrderDetail(int id) async {
    try {
      final response = await ApiHelper.get(
        Uri.parse('${Variables.baseUrl}/api/orders/$id'),
        headers: await _authHeaders(),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Right(Order.fromMap(data['data']));
      }
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Pesanan tidak ditemukan');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, String>> cancelOrder(int id, {String? reason}) async {
    try {
      final response = await ApiHelper.post(
        Uri.parse('${Variables.baseUrl}/api/orders/$id/cancel'),
        headers: await _authHeaders(),
        body: jsonEncode(
            {if (reason != null && reason.isNotEmpty) 'reason': reason}),
      );
      if (response.statusCode == 200) {
        return const Right('Pesanan berhasil dibatalkan');
      }
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Gagal membatalkan pesanan');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, String>> repayOrder(int id) async {
    try {
      final response = await ApiHelper.post(
        Uri.parse('${Variables.baseUrl}/api/orders/$id/repay'),
        headers: await _authHeaders(),
        body: jsonEncode({}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Right(data['data']?['paymentUrl'] ?? '');
      }
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Gagal membuat ulang pembayaran');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, OrderShipping>> getTracking(int id) async {
    try {
      final response = await ApiHelper.get(
        Uri.parse('${Variables.baseUrl}/api/orders/$id/tracking'),
        headers: await _authHeaders(),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Right(OrderShipping.fromMap(data['data']));
      }
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Gagal memuat tracking');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }
}
