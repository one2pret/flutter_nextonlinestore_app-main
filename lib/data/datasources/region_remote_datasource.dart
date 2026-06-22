import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class RegionItem {
  final String id;
  final String name;
  RegionItem({required this.id, required this.name});

  factory RegionItem.fromMap(Map<String, dynamic> map) {
    return RegionItem(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
    );
  }
}

class NominatimResult {
  final double lat;
  final double lng;
  final String displayName;
  final String? province;
  final String? city;
  final String? district;
  final String? postalCode;

  NominatimResult({
    required this.lat,
    required this.lng,
    required this.displayName,
    this.province,
    this.city,
    this.district,
    this.postalCode,
  });
}

class RegionRemoteDatasource {
  static const _emsifaBase =
      'https://www.emsifa.com/api-wilayah-indonesia/api';
  static const _nominatimBase = 'https://nominatim.openstreetmap.org';

  Future<Either<String, List<RegionItem>>> getProvinces() async {
    try {
      final response = await http.get(Uri.parse('$_emsifaBase/provinces.json'));
      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List;
        return Right(list.map((e) => RegionItem.fromMap(e)).toList());
      }
      return const Left('Gagal memuat provinsi');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, List<RegionItem>>> getCities(String provinceId) async {
    try {
      final response = await http
          .get(Uri.parse('$_emsifaBase/regencies/$provinceId.json'));
      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List;
        return Right(list.map((e) => RegionItem.fromMap(e)).toList());
      }
      return const Left('Gagal memuat kota');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, List<RegionItem>>> getDistricts(String cityId) async {
    try {
      final response = await http
          .get(Uri.parse('$_emsifaBase/districts/$cityId.json'));
      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List;
        return Right(list.map((e) => RegionItem.fromMap(e)).toList());
      }
      return const Left('Gagal memuat kecamatan');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, NominatimResult>> reverseGeocode(
      double lat, double lng) async {
    try {
      final uri = Uri.parse('$_nominatimBase/reverse').replace(
        queryParameters: {
          'format': 'json',
          'lat': lat.toString(),
          'lon': lng.toString(),
          'addressdetails': '1',
        },
      );
      final response = await http.get(uri, headers: {
        'Accept-Language': 'id',
        'User-Agent': 'NextElektronikApp/1.0',
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final addr = data['address'] ?? {};
        return Right(NominatimResult(
          lat: lat,
          lng: lng,
          displayName: data['display_name'] ?? '',
          province: addr['state'],
          city: addr['city'] ?? addr['town'] ?? addr['county'],
          district: addr['suburb'] ?? addr['village'] ?? addr['neighbourhood'],
          postalCode: addr['postcode'],
        ));
      }
      return const Left('Gagal memuat alamat');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }
}
