# Sesi 03 — Data Layer (Models, Datasource, API Helper)

> ⏱️ Estimasi: 60 menit
> 🎯 Tujuan: Peserta paham pattern data layer Flutter — `Either<String, T>` untuk error, `fromMap/toMap` untuk model, `ApiHelper` untuk HTTP + log, dan `SharedPreferences` untuk simpan token.

---

## 1. Konsep (10 menit)

### Either Pattern (dartz)
`Either<L, R>` adalah type yang isinya **L (Left = error)** atau **R (Right = success)**. Lebih explicit dari try-catch.

```dart
// Manual try-catch (ribet)
try {
  final user = await loginApi(...);
  // success path
} catch (e) {
  // error path
}

// Either (clean)
final result = await datasource.login(...);
result.fold(
  (error) => print('Error: $error'),  // Left
  (data) => print('Success: $data'),  // Right
);
```

### Konvensi Project Ini
- **Datasource** SELALU return `Future<Either<String, T>>`.
  - `Left` = pesan error string (sudah user-friendly Indonesian).
  - `Right` = data sukses (Model atau String konfirmasi).
- **Model** pakai `fromMap()` / `toMap()` (Map ↔ Object), `fromJson()` / `toJson()` (String JSON ↔ Object).
- **API Response Format Backend**:
  ```json
  { "success": true, "data": { ... }, "meta": { ... } }    // success
  { "success": false, "error": "Pesan error" }              // error
  ```

---

## 2. API Helper (HTTP Wrapper + Logging)

Buat `lib/data/datasources/api_helper.dart`:

```dart
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  static const _divider = '══════════════════════════════════════════════════';
  static const _subDivider = '──────────────────────────────────────────────────';

  static Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    _logRequest('GET', url, headers: headers);
    final stopwatch = Stopwatch()..start();
    try {
      final response = await http.get(url, headers: headers);
      stopwatch.stop();
      _logResponse('GET', url, response, stopwatch.elapsedMilliseconds);
      return response;
    } catch (e) {
      stopwatch.stop();
      _logError('GET', url, e, stopwatch.elapsedMilliseconds);
      rethrow;
    }
  }

  static Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body}) async {
    _logRequest('POST', url, headers: headers, body: body);
    final stopwatch = Stopwatch()..start();
    try {
      final response = await http.post(url, headers: headers, body: body);
      stopwatch.stop();
      _logResponse('POST', url, response, stopwatch.elapsedMilliseconds);
      return response;
    } catch (e) {
      stopwatch.stop();
      _logError('POST', url, e, stopwatch.elapsedMilliseconds);
      rethrow;
    }
  }

  static Future<http.Response> put(Uri url, {Map<String, String>? headers, Object? body}) async {
    _logRequest('PUT', url, headers: headers, body: body);
    final stopwatch = Stopwatch()..start();
    try {
      final response = await http.put(url, headers: headers, body: body);
      stopwatch.stop();
      _logResponse('PUT', url, response, stopwatch.elapsedMilliseconds);
      return response;
    } catch (e) {
      stopwatch.stop();
      _logError('PUT', url, e, stopwatch.elapsedMilliseconds);
      rethrow;
    }
  }

  static Future<http.Response> delete(Uri url, {Map<String, String>? headers, Object? body}) async {
    _logRequest('DELETE', url, headers: headers, body: body);
    final stopwatch = Stopwatch()..start();
    try {
      final response = await http.delete(url, headers: headers, body: body);
      stopwatch.stop();
      _logResponse('DELETE', url, response, stopwatch.elapsedMilliseconds);
      return response;
    } catch (e) {
      stopwatch.stop();
      _logError('DELETE', url, e, stopwatch.elapsedMilliseconds);
      rethrow;
    }
  }

  // -------- Logging --------

  static void _logRequest(String method, Uri url, {Map<String, String>? headers, Object? body}) {
    if (!kDebugMode) return;
    debugPrint('\n$_divider');
    debugPrint('REQUEST: $method $url');
    debugPrint(_subDivider);
    if (headers != null && headers.isNotEmpty) {
      debugPrint('Headers:');
      for (final entry in headers.entries) {
        debugPrint('  ${entry.key}: ${_maskSensitive(entry.key, entry.value)}');
      }
    }
    if (body != null) {
      debugPrint('Body:');
      debugPrint('  ${_prettyBody(body)}');
    }
    debugPrint(_subDivider);
  }

  static void _logResponse(String method, Uri url, http.Response response, int durationMs) {
    if (!kDebugMode) return;
    final status = response.statusCode;
    final tag = status >= 200 && status < 300 ? 'SUCCESS' : 'FAILED';
    debugPrint('RESPONSE: $tag $status  ($method $url)  [${durationMs}ms]');
    debugPrint(_subDivider);
    debugPrint('Response Body:');
    debugPrint('  ${_prettyJson(response.body)}');
    debugPrint('$_divider\n');
  }

  static void _logError(String method, Uri url, Object error, int durationMs) {
    if (!kDebugMode) return;
    debugPrint('RESPONSE: ERROR  ($method $url)  [${durationMs}ms]');
    debugPrint('  $error');
    debugPrint('$_divider\n');
  }

  static String _maskSensitive(String key, String value) {
    if (key.toLowerCase() == 'authorization' && value.length > 20) {
      return '${value.substring(0, 15)}...${value.substring(value.length - 4)}';
    }
    return value;
  }

  static String _prettyBody(Object body) {
    if (body is String) return _prettyJson(body);
    if (body is Map) {
      final safe = Map<String, dynamic>.from(body);
      if (safe.containsKey('password')) safe['password'] = '***';
      return _formatJson(safe);
    }
    return body.toString();
  }

  static String _prettyJson(String raw) {
    try {
      return _formatJson(jsonDecode(raw));
    } catch (_) {
      return raw.length > 500 ? '${raw.substring(0, 500)}...' : raw;
    }
  }

  static String _formatJson(Object? obj) =>
      const JsonEncoder.withIndent('  ').convert(obj);
}
```

### Fitur ApiHelper:
- Wrapper untuk `http.get/post/put/delete`
- Auto-log request & response (kDebugMode only — production tidak log)
- Mask `Authorization` header (security)
- Mask field `password` di body (security)
- Pretty-print JSON
- Timing measurement (durasi tiap request)

> 💡 **Tips**: developer love this — debugging API call jadi mudah lihat di terminal.

---

## 3. AuthLocalDatasource (Token Storage)

Buat `lib/data/datasources/auth_local_datasource.dart`:

```dart
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDatasource {
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> saveUser(String userJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', userJson);
  }

  Future<String?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user');
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
```

### Penggunaan:
```dart
// Saat login sukses
await AuthLocalDatasource().saveToken(authResponse.token!);
await AuthLocalDatasource().saveUser(authResponse.user!.toJson());

// Saat call API
final token = await AuthLocalDatasource().getToken();
headers: {'Authorization': 'Bearer $token'}

// Cek login state (di splash)
final loggedIn = await AuthLocalDatasource().isLoggedIn();

// Logout
await AuthLocalDatasource().clearAll();
```

---

## 4. Model: AuthResponseModel & User

Buat `lib/data/models/response/auth_response_model.dart`:

```dart
import 'dart:convert';

class AuthResponseModel {
  final String? token;
  final User? user;

  AuthResponseModel({this.token, this.user});

  factory AuthResponseModel.fromMap(Map<String, dynamic> map) {
    return AuthResponseModel(
      token: map['data']?['token'],
      user: map['data']?['user'] != null
          ? User.fromMap(map['data']['user'])
          : null,
    );
  }

  factory AuthResponseModel.fromJson(String source) =>
      AuthResponseModel.fromMap(jsonDecode(source));
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? role;

  User({this.id, this.name, this.email, this.phone, this.role});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toInt(),
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      role: map['role'],
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'role': role,
  };

  String toJson() => jsonEncode(toMap());
  factory User.fromJson(String source) => User.fromMap(jsonDecode(source));
}
```

### Konvensi:
1. **SEMUA field nullable** dengan `?` — API bisa return null
2. `fromMap()` parse dari `Map<String, dynamic>` (sudah di-decode)
3. `fromJson(String)` parse langsung dari raw JSON string
4. `toMap()` untuk serialize (untuk simpan di SharedPreferences atau debug)
5. `toJson()` return raw JSON string
6. Safe parse: `map['id']?.toInt()` — handle null + tipe ganda (kalau API kirim string)

---

## 5. Model: Product, Category, PaginationMeta

Buat `lib/data/models/response/product_response_model.dart`:

```dart
import 'dart:convert';

class ProductResponseModel {
  final bool? success;
  final List<Product>? data;
  final PaginationMeta? meta;

  ProductResponseModel({this.success, this.data, this.meta});

  factory ProductResponseModel.fromJson(String source) {
    final map = jsonDecode(source);
    return ProductResponseModel(
      success: map['success'],
      data: map['data'] != null
          ? List<Product>.from(map['data'].map((x) => Product.fromMap(x)))
          : null,
      meta: map['meta'] != null ? PaginationMeta.fromMap(map['meta']) : null,
    );
  }
}

class Product {
  final int? id;
  final int? categoryId;
  final String? name;
  final String? slug;
  final String? description;
  final String? price;        // String decimal: "299000.00"
  final String? image;
  final int? stock;
  final int? weight;          // Gram (untuk shipping)
  final bool? isActive;
  final bool? isFeatured;
  final String? createdAt;
  final String? updatedAt;
  final Category? category;

  Product({
    this.id, this.categoryId, this.name, this.slug, this.description,
    this.price, this.image, this.stock, this.weight,
    this.isActive, this.isFeatured, this.createdAt, this.updatedAt, this.category,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id']?.toInt(),
      categoryId: map['categoryId']?.toInt(),
      name: map['name'],
      slug: map['slug'],
      description: map['description'],
      price: map['price']?.toString(),
      image: map['image'],
      stock: map['stock']?.toInt(),
      weight: map['weight']?.toInt(),
      isActive: map['isActive'],
      isFeatured: map['isFeatured'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      category: map['category'] != null
          ? Category.fromMap(map['category'])
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id, 'categoryId': categoryId, 'name': name, 'slug': slug,
    'description': description, 'price': price, 'image': image,
    'stock': stock, 'weight': weight,
    'isActive': isActive, 'isFeatured': isFeatured,
  };

  String get imageUrl => image ?? '';
}

class Category {
  final int? id;
  final String? name;
  final String? slug;
  final String? description;
  final String? image;
  final String? createdAt;
  final String? updatedAt;

  Category({this.id, this.name, this.slug, this.description, this.image, this.createdAt, this.updatedAt});

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id']?.toInt(),
      name: map['name'],
      slug: map['slug'],
      description: map['description'],
      image: map['image'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }
}

class PaginationMeta {
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPages;

  PaginationMeta({this.page, this.limit, this.total, this.totalPages});

  factory PaginationMeta.fromMap(Map<String, dynamic> map) {
    return PaginationMeta(
      page: map['page']?.toInt(),
      limit: map['limit']?.toInt(),
      total: map['total']?.toInt(),
      totalPages: map['totalPages']?.toInt(),
    );
  }
}
```

> 💡 **Pattern**: tiap fitur punya file model sendiri (`product_response_model.dart`, `cart_response_model.dart`, dll). Tidak satu file model raksasa.

---

## 6. Request Model

Buat `lib/data/models/request/login_request_model.dart`:

```dart
import 'dart:convert';

class LoginRequestModel {
  final String email;
  final String password;

  LoginRequestModel({required this.email, required this.password});

  Map<String, dynamic> toMap() => {'email': email, 'password': password};
  String toJson() => jsonEncode(toMap());
}
```

Buat `lib/data/models/request/register_request_model.dart`:

```dart
import 'dart:convert';

class RegisterRequestModel {
  final String name;
  final String email;
  final String phone;
  final String password;

  RegisterRequestModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'email': email,
    'phone': phone,
    'password': password,
  };

  String toJson() => jsonEncode(toMap());
}
```

> 💡 **Catatan**: request model TIDAK punya field nullable. Field semua `required` — karena ini data yang kita kirim, harus lengkap.

---

## 7. AuthRemoteDatasource (Implementasi Either Pattern)

Buat `lib/data/datasources/auth_remote_datasource.dart`:

```dart
import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../core/constants/variables.dart';
import '../models/request/login_request_model.dart';
import '../models/request/register_request_model.dart';
import '../models/response/auth_response_model.dart';
import 'api_helper.dart';
import 'auth_local_datasource.dart';

class AuthRemoteDatasource {
  Future<Either<String, AuthResponseModel>> login(LoginRequestModel request) async {
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

  // updateProfile, changePassword, deleteAccount — lihat repo akhir untuk pattern lengkap
}
```

### Pattern Anatomy:
```dart
Future<Either<String, T>> someMethod() async {
  try {
    // 1. Ambil token (kalau perlu auth)
    final token = await AuthLocalDatasource().getToken();

    // 2. Call API via ApiHelper
    final response = await ApiHelper.post(uri, headers: {...}, body: ...);

    // 3. Cek status code
    if (response.statusCode == 200) {
      // 4a. Success → Right(data)
      return Right(Model.fromJson(response.body));
    } else {
      // 4b. Error from server → Left(message)
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Default error message');
    }
  } catch (e) {
    // 4c. Network/parse error → Left(catch-all)
    return Left('Terjadi kesalahan: $e');
  }
}
```

---

## 8. Test Manual: Login API

Untuk test datasource, sementara modify `main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_onlinestore_app/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_onlinestore_app/data/models/request/login_request_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Test Login API')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final result = await AuthRemoteDatasource().login(
                LoginRequestModel(
                  email: 'customer@nextelektronik.com',
                  password: 'password123',
                ),
              );
              result.fold(
                (err) => debugPrint('❌ Error: $err'),
                (data) => debugPrint('✅ Token: ${data.token}\n👤 User: ${data.user?.name}'),
              );
            },
            child: const Text('Test Login'),
          ),
        ),
      ),
    );
  }
}
```

Run app → tap tombol → cek terminal. Harusnya muncul:
```
══════════════════════════════════════════════════
REQUEST: POST https://nextelektronik.jagofullstack.com/api/auth/login
──────────────────────────────────────────────────
Headers:
  Content-Type: application/json
Body:
  {
    "email": "customer@nextelektronik.com",
    "password": "***"
  }
──────────────────────────────────────────────────
RESPONSE: SUCCESS 200  (POST ...)  [432ms]
...
✅ Token: eyJhbGciOiJIUzI1NiI...
👤 User: Customer Demo
```

✅ **Checkpoint**: token muncul di console.

> 💡 Kalau error "Terjadi kesalahan: SocketException", cek baseUrl + koneksi internet.

---

## 9. Best Practice & Patterns

### A. Selalu Wrap di try-catch Luar
```dart
// BENAR
Future<Either<String, T>> method() async {
  try {
    // ... happy path
  } catch (e) {
    return Left('Terjadi kesalahan: $e');
  }
}

// SALAH (lupa try-catch — bisa crash)
Future<Either<String, T>> method() async {
  final response = await ApiHelper.get(...);  // Bisa throw SocketException
  return Right(...);
}
```

### B. User-Friendly Error Message
```dart
// BENAR
return Left(error['error'] ?? 'Gagal memuat produk');

// SALAH
return Left(response.body);  // Bisa expose JSON internal
return Left(e.toString());   // Expose stack trace
```

### C. Type Inference dengan Either
```dart
// Type T jelas dari signature, no need cast
Future<Either<String, ProductResponseModel>> getProducts() async { ... }

result.fold(
  (err) => ...,           // err: String
  (data) => data.data,    // data: ProductResponseModel
);
```

---

## ✅ Checklist Akhir Sesi 03

- [ ] `data/datasources/api_helper.dart` — ApiHelper class dengan log
- [ ] `data/datasources/auth_local_datasource.dart` — SharedPreferences wrapper
- [ ] `data/models/response/auth_response_model.dart` — AuthResponseModel + User
- [ ] `data/models/response/product_response_model.dart` — Product + Category + PaginationMeta
- [ ] `data/models/request/login_request_model.dart`
- [ ] `data/models/request/register_request_model.dart`
- [ ] `data/datasources/auth_remote_datasource.dart` — login, register, getProfile
- [ ] Test login API berhasil (token muncul di console)
- [ ] Log ApiHelper terlihat di terminal (request + response)

---

## 🐛 Common Issues

| Error | Penyebab | Fix |
|-------|----------|-----|
| `SocketException: Failed host lookup` | Tidak ada internet / DNS error | Cek koneksi, ping baseUrl |
| `Connection refused` di emulator | Backend localhost ga accessible | Pakai `10.0.2.2` di Android emulator |
| `FormatException: Unexpected character` | Response bukan JSON (HTML error page) | Cek status code, mungkin 404/500 |
| `type 'Null' is not a subtype of type 'String'` | API return null untuk field non-nullable | Pastikan SEMUA field model nullable `?` |
| `Either<String, T>` tidak ke-import | Lupa import dartz | `import 'package:dartz/dartz.dart';` |
| Token tidak persist setelah restart | SharedPreferences tidak save | Pastikan pakai `await` di `saveToken()` |

---

## 📝 Latihan Mandiri

1. Bikin `CategoryRemoteDatasource` dengan method `getCategories()` (endpoint: `GET /api/categories`)
2. Bikin `BannerRemoteDatasource` dengan method `getBanners()` (endpoint: `GET /api/banners`)
3. Test dua-duanya dengan button di main, lihat log di console
4. Tambahkan method `updateProfile({String? name, String? phone})` di AuthRemoteDatasource

---

## ➡️ Lanjut ke [Sesi 04 — Authentication](./04-auth.md)
