import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../core/constants/variables.dart';
import '../models/response/product_response_model.dart';
import 'api_helper.dart';

class ProductRemoteDatasource {
  Future<Either<String, ProductResponseModel>> getProducts({
    String? category,
    String? search,
    bool? featured,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (category != null) 'category': category,
        if (search != null) 'search': search,
        if (featured != null) 'featured': featured.toString(),
      };

      final uri = Uri.parse('${Variables.baseUrl}/api/products')
          .replace(queryParameters: queryParams);

      final response = await ApiHelper.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return Right(ProductResponseModel.fromJson(response.body));
      }
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Gagal memuat produk');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, Product>> getProductDetail(int id) async {
    try {
      final response = await ApiHelper.get(
        Uri.parse('${Variables.baseUrl}/api/products/$id'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Right(Product.fromMap(data['data']));
      }
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Produk tidak ditemukan');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }
}
