import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../core/constants/variables.dart';
import 'api_helper.dart';
import 'auth_local_datasource.dart';

class FcmRemoteDatasource {
  Future<Either<String, Unit>> registerToken(String? fcmToken) async {
    try {
      final token = await AuthLocalDatasource().getToken();
      if (token == null || token.isEmpty) {
        return const Left('Belum login, FCM token tidak dikirim');
      }

      final response = await ApiHelper.put(
        Uri.parse('${Variables.baseUrl}/api/users/me/fcm-token'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'fcmToken': fcmToken}),
      );

      if (response.statusCode == 200) return const Right(unit);

      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Gagal mendaftarkan FCM token');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }
}
