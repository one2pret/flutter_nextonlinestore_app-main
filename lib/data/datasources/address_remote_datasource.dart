import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../core/constants/variables.dart';
import '../models/request/address_request_model.dart';
import '../models/response/address_response_model.dart';
import 'api_helper.dart';
import 'auth_local_datasource.dart';

class AddressRemoteDatasource {
  Future<Map<String, String>> _authHeaders() async {
    final token = await AuthLocalDatasource().getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Either<String, AddressResponseModel>> getAddresses() async {
    try {
      final response = await ApiHelper.get(
        Uri.parse('${Variables.baseUrl}/api/addresses'),
        headers: await _authHeaders(),
      );
      if (response.statusCode == 200) {
        return Right(AddressResponseModel.fromJson(response.body));
      }
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Gagal memuat alamat');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, Address>> createAddress(
      AddressRequestModel request) async {
    try {
      final response = await ApiHelper.post(
        Uri.parse('${Variables.baseUrl}/api/addresses'),
        headers: await _authHeaders(),
        body: request.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Right(Address.fromMap(data['data']));
      }
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Gagal membuat alamat');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, Address>> updateAddress(
      int id, AddressRequestModel request) async {
    try {
      final response = await ApiHelper.put(
        Uri.parse('${Variables.baseUrl}/api/addresses/$id'),
        headers: await _authHeaders(),
        body: request.toJson(),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Right(Address.fromMap(data['data']));
      }
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Gagal memperbarui alamat');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, String>> deleteAddress(int id) async {
    try {
      final response = await ApiHelper.delete(
        Uri.parse('${Variables.baseUrl}/api/addresses/$id'),
        headers: await _authHeaders(),
      );
      if (response.statusCode == 200) {
        return const Right('Alamat berhasil dihapus');
      }
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Gagal menghapus alamat');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, String>> setDefaultAddress(int id) async {
    try {
      final response = await ApiHelper.put(
        Uri.parse('${Variables.baseUrl}/api/addresses/$id/default'),
        headers: await _authHeaders(),
      );
      if (response.statusCode == 200) {
        return const Right('Alamat utama berhasil diubah');
      }
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Gagal mengubah alamat utama');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }
}
