import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../core/constants/variables.dart';
import '../models/response/shipping_rate_response_model.dart';
import 'api_helper.dart';
import 'auth_local_datasource.dart';

class ShippingRemoteDatasource {
  Future<Either<String, ShippingRateResponseModel>> calculateRates(
      int addressId) async {
    try {
      final token = await AuthLocalDatasource().getToken();
      final response = await ApiHelper.post(
        Uri.parse('${Variables.baseUrl}/api/shipping/rates'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'addressId': addressId}),
      );
      if (response.statusCode == 200) {
        return Right(ShippingRateResponseModel.fromJson(response.body));
      }
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Gagal menghitung ongkos kirim');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }
}
