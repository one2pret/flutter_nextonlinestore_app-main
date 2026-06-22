import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../core/constants/variables.dart';
import '../models/response/product_response_model.dart';
import 'api_helper.dart';

class CategoryRemoteDatasource {
  Future<Either<String, List<Category>>> getCategories() async {
    try {
      final response = await ApiHelper.get(
        Uri.parse('${Variables.baseUrl}/api/categories'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Right(
          (data['data'] as List).map((x) => Category.fromMap(x)).toList(),
        );
      }
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Gagal memuat kategori');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }
}
