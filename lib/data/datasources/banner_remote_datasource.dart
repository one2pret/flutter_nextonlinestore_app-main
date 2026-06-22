import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../core/constants/variables.dart';
import '../models/response/banner_response_model.dart';
import 'api_helper.dart';

class BannerRemoteDatasource {
  Future<Either<String, List<Banner>>> getBanners() async {
    try {
      final response = await ApiHelper.get(
        Uri.parse('${Variables.baseUrl}/api/banners'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Right(
          (data['data'] as List).map((x) => Banner.fromMap(x)).toList(),
        );
      }
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Gagal memuat banner');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }
}
