import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../core/constants/variables.dart';
import '../models/request/login_request_model.dart';
import '../models/request/register_request_model.dart';
import '../models/response/auth_response_model.dart';
import 'api_helper.dart';
import 'auth_local_datasource.dart';

class AuthRemoteDatasource {
  Future<Either<String, AuthResponseModel>> login(
      LoginRequestModel request) async {
    try {
      final response = await ApiHelper.post(
        Uri.parse('${Variables.baseUrl}/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: request.toJson(),
      );

      if (response.statusCode == 200) {
        return Right(AuthResponseModel.fromJson(response.body));
      } else {
        final error = jsonDecode(response.body);
        return Left(error['error'] ?? 'Login gagal');
      }
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, String>> register(RegisterRequestModel request) async {
    try {
      final response = await ApiHelper.post(
        Uri.parse('${Variables.baseUrl}/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right('Registrasi berhasil');
      } else {
        final error = jsonDecode(response.body);
        return Left(error['error'] ?? 'Registrasi gagal');
      }
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, User>> updateProfile({
    required String name,
    required String phone,
  }) async {
    try {
      final token = await AuthLocalDatasource().getToken();
      final response = await ApiHelper.put(
        Uri.parse('${Variables.baseUrl}/api/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'name': name, 'phone': phone}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Right(User.fromMap(data['data']));
      } else {
        final error = jsonDecode(response.body);
        return Left(error['error'] ?? 'Gagal memperbarui profil');
      }
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, User>> getProfile() async {
    try {
      final token = await AuthLocalDatasource().getToken();
      final response = await ApiHelper.get(
        Uri.parse('${Variables.baseUrl}/api/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Right(User.fromMap(data['data']));
      } else {
        final error = jsonDecode(response.body);
        return Left(error['error'] ?? 'Gagal memuat profil');
      }
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }
}
