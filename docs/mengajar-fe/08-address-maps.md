# Sesi 08 — Address & Maps Integration

> ⏱️ Estimasi: 75 menit
> 🎯 Tujuan: Peserta paham CRUD alamat, integrasi flutter_map (OpenStreetMap), geolocator (current location), region dropdown (provinsi/kota/kecamatan) dari API publik, dan reverse-geocode lewat Nominatim.

---

## 1. Konsep (10 menit)

### Kenapa Alamat Penting?
Tanpa alamat, tidak bisa hitung ongkir & tidak bisa kirim. Tiap user bisa punya banyak alamat (rumah, kantor) — satu di-set sebagai default.

### Stack Maps & Region
| Tool | Fungsi | Cost |
|------|--------|------|
| **flutter_map** | Render map dari OpenStreetMap tiles | Gratis (no API key) |
| **geolocator** | Get current location user | Gratis (butuh permission) |
| **Nominatim** | Search & reverse geocode (lat/lng ↔ alamat) | Gratis (rate-limited 1 req/sec) |
| **Emsifa API** | Daftar provinsi/kota/kecamatan Indonesia | Gratis |

> 💡 **Why not Google Maps?** Berbayar setelah free tier (200 USD/bulan). Untuk MVP/UMKM, OpenStreetMap cukup.

### Format Backend
Backend simpan alamat dengan:
- Text fields: `recipientName`, `phone`, `address`, `detail`, `postalCode`, `label`
- Region: `province`, `provinceId`, `city`, `cityId`, `district`, `districtId`
- Coordinate: `latitude`, `longitude` (string decimal)
- Flag: `isDefault` (boolean)

---

## 2. Address Models

`lib/data/models/request/address_request_model.dart`:
```dart
import 'dart:convert';

class AddressRequestModel {
  final String recipientName;
  final String phone;
  final String address;
  final String? detail;
  final String province;
  final String? provinceId;
  final String city;
  final String? cityId;
  final String? district;
  final String? districtId;
  final String postalCode;
  final String? latitude;
  final String? longitude;
  final String? label;
  final bool? isDefault;

  AddressRequestModel({
    required this.recipientName,
    required this.phone,
    required this.address,
    this.detail,
    required this.province,
    this.provinceId,
    required this.city,
    this.cityId,
    this.district,
    this.districtId,
    required this.postalCode,
    this.latitude,
    this.longitude,
    this.label,
    this.isDefault,
  });

  Map<String, dynamic> toMap() => {
    'recipientName': recipientName,
    'phone': phone,
    'address': address,
    'detail': detail,
    'province': province,
    'provinceId': provinceId,
    'city': city,
    'cityId': cityId,
    'district': district,
    'districtId': districtId,
    'postalCode': postalCode,
    'latitude': latitude,
    'longitude': longitude,
    'label': label,
    'isDefault': isDefault,
  };

  String toJson() => jsonEncode(toMap());
}
```

`lib/data/models/response/address_response_model.dart`:
```dart
import 'dart:convert';

class AddressResponseModel {
  final bool? success;
  final List<Address>? data;
  AddressResponseModel({this.success, this.data});

  factory AddressResponseModel.fromJson(String source) {
    final map = jsonDecode(source);
    return AddressResponseModel(
      success: map['success'],
      data: map['data'] != null
          ? List<Address>.from(map['data'].map((x) => Address.fromMap(x)))
          : null,
    );
  }
}

class Address {
  final int? id;
  final int? userId;
  final String? recipientName;
  final String? phone;
  final String? address;
  final String? detail;
  final String? province;
  final String? provinceId;
  final String? city;
  final String? cityId;
  final String? district;
  final String? districtId;
  final String? postalCode;
  final String? latitude;
  final String? longitude;
  final String? label;
  final bool? isDefault;
  final String? createdAt;
  final String? updatedAt;

  Address({
    this.id, this.userId, this.recipientName, this.phone, this.address,
    this.detail, this.province, this.provinceId, this.city, this.cityId,
    this.district, this.districtId, this.postalCode, this.latitude,
    this.longitude, this.label, this.isDefault, this.createdAt, this.updatedAt,
  });

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id']?.toInt(),
      userId: map['userId']?.toInt(),
      recipientName: map['recipientName'],
      phone: map['phone'],
      address: map['address'],
      detail: map['detail'],
      province: map['province'],
      provinceId: map['provinceId']?.toString(),
      city: map['city'],
      cityId: map['cityId']?.toString(),
      district: map['district'],
      districtId: map['districtId']?.toString(),
      postalCode: map['postalCode'],
      latitude: map['latitude']?.toString(),
      longitude: map['longitude']?.toString(),
      label: map['label'],
      isDefault: map['isDefault'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  String get fullAddress {
    final parts = <String>[];
    if (address != null && address!.isNotEmpty) parts.add(address!);
    if (detail != null && detail!.isNotEmpty) parts.add(detail!);
    if (district != null && district!.isNotEmpty) parts.add(district!);
    if (city != null && city!.isNotEmpty) parts.add(city!);
    if (province != null && province!.isNotEmpty) parts.add(province!);
    if (postalCode != null && postalCode!.isNotEmpty) parts.add(postalCode!);
    return parts.join(', ');
  }
}
```

---

## 3. AddressRemoteDatasource

`lib/data/datasources/address_remote_datasource.dart`:

```dart
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

  Future<Either<String, Address>> createAddress(AddressRequestModel request) async {
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

  Future<Either<String, Address>> updateAddress(int id, AddressRequestModel request) async {
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
      if (response.statusCode == 200) return const Right('Alamat berhasil dihapus');
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
      if (response.statusCode == 200) return const Right('Alamat utama berhasil diubah');
      final error = jsonDecode(response.body);
      return Left(error['error'] ?? 'Gagal mengubah alamat utama');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }
}
```

---

## 4. RegionRemoteDatasource (Emsifa + Nominatim)

`lib/data/datasources/region_remote_datasource.dart`:

```dart
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
    required this.lat, required this.lng, required this.displayName,
    this.province, this.city, this.district, this.postalCode,
  });
}

class RegionRemoteDatasource {
  static const _emsifaBase = 'https://www.emsifa.com/api-wilayah-indonesia/api';
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
      final response = await http.get(Uri.parse('$_emsifaBase/regencies/$provinceId.json'));
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
      final response = await http.get(Uri.parse('$_emsifaBase/districts/$cityId.json'));
      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List;
        return Right(list.map((e) => RegionItem.fromMap(e)).toList());
      }
      return const Left('Gagal memuat kecamatan');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, NominatimResult>> reverseGeocode(double lat, double lng) async {
    try {
      final uri = Uri.parse('$_nominatimBase/reverse').replace(queryParameters: {
        'format': 'json',
        'lat': lat.toString(),
        'lon': lng.toString(),
        'addressdetails': '1',
      });
      final response = await http.get(uri, headers: {
        'Accept-Language': 'id',
        'User-Agent': 'NextElektronikApp/1.0',  // WAJIB: Nominatim block default user agent
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final addr = data['address'] ?? {};
        return Right(NominatimResult(
          lat: lat, lng: lng,
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
```

> ⚠️ **Penting**: Nominatim WAJIB pakai `User-Agent` custom + email contact. Default user-agent http akan diblock.

---

## 5. AddressBloc

Pattern sama (initial/loading/loaded/error). Tetapi pakai event lebih banyak:

```dart
// event
@freezed
sealed class AddressEvent with _$AddressEvent {
  const factory AddressEvent.getAddresses() = _GetAddresses;
  const factory AddressEvent.createAddress(AddressRequestModel request) = _CreateAddress;
  const factory AddressEvent.updateAddress(int id, AddressRequestModel request) = _UpdateAddress;
  const factory AddressEvent.deleteAddress(int id) = _DeleteAddress;
  const factory AddressEvent.setDefault(int id) = _SetDefault;
}

// state
@freezed
sealed class AddressState with _$AddressState {
  const factory AddressState.initial() = _Initial;
  const factory AddressState.loading() = _Loading;
  const factory AddressState.loaded(List<Address> addresses) = _Loaded;
  const factory AddressState.success(String message) = _Success;
  const factory AddressState.error(String message) = _Error;
}
```

Implementasi:
```dart
class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressRemoteDatasource _datasource;
  AddressBloc(this._datasource) : super(const AddressState.initial()) {
    on<_GetAddresses>(_onGet);
    on<_CreateAddress>(_onCreate);
    on<_UpdateAddress>(_onUpdate);
    on<_DeleteAddress>(_onDelete);
    on<_SetDefault>(_onSetDefault);
  }

  Future<void> _onGet(_GetAddresses event, Emitter emit) async {
    emit(const AddressState.loading());
    final result = await _datasource.getAddresses();
    result.fold(
      (err) => emit(AddressState.error(err)),
      (data) => emit(AddressState.loaded(data.data ?? [])),
    );
  }

  Future<void> _onCreate(_CreateAddress event, Emitter emit) async {
    emit(const AddressState.loading());
    final result = await _datasource.createAddress(event.request);
    await result.fold(
      (err) async => emit(AddressState.error(err)),
      (_) async {
        // re-fetch list
        final list = await _datasource.getAddresses();
        list.fold(
          (e) => emit(AddressState.error(e)),
          (data) => emit(AddressState.loaded(data.data ?? [])),
        );
      },
    );
  }

  // Update, Delete, SetDefault — pattern sama: action → re-fetch
}
```

Run build_runner.

---

## 6. Permission Android (Geolocator)

Edit `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest ...>
  <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
  <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
  <uses-permission android:name="android.permission.INTERNET" />
  ...
</manifest>
```

iOS — edit `ios/Runner/Info.plist`:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Aplikasi membutuhkan lokasi untuk menentukan alamat pengiriman.</string>
```

---

## 7. MapPickerWidget (flutter_map)

`lib/presentation/address/widgets/map_picker_widget.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'package:flutter_onlinestore_app/core/constants/colors.dart';

class MapPickerWidget extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;
  final ValueChanged<LatLng> onLocationPicked;

  const MapPickerWidget({
    super.key,
    this.initialLat,
    this.initialLng,
    required this.onLocationPicked,
  });

  @override
  State<MapPickerWidget> createState() => _MapPickerWidgetState();
}

class _MapPickerWidgetState extends State<MapPickerWidget> {
  final _mapController = MapController();
  LatLng _picked = const LatLng(-6.2088, 106.8456); // Jakarta default

  @override
  void initState() {
    super.initState();
    if (widget.initialLat != null && widget.initialLng != null) {
      _picked = LatLng(widget.initialLat!, widget.initialLng!);
    } else {
      _useCurrentLocation();
    }
  }

  Future<void> _useCurrentLocation() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return;
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }
    final pos = await Geolocator.getCurrentPosition();
    if (!mounted) return;
    setState(() {
      _picked = LatLng(pos.latitude, pos.longitude);
    });
    _mapController.move(_picked, 16);
    widget.onLocationPicked(_picked);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _picked,
              initialZoom: 15,
              onTap: (_, latlng) {
                setState(() => _picked = latlng);
                widget.onLocationPicked(latlng);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.jagoflutter.nextelektronik',
              ),
              MarkerLayer(markers: [
                Marker(
                  point: _picked,
                  width: 40, height: 40,
                  child: const Icon(Icons.location_on, color: AppColors.error, size: 40),
                ),
              ]),
            ],
          ),
          Positioned(
            right: 12, top: 12,
            child: FloatingActionButton.small(
              backgroundColor: AppColors.white,
              onPressed: _useCurrentLocation,
              child: const Icon(Icons.my_location, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 8. AddressFormPage

`lib/presentation/address/pages/address_form_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import 'package:flutter_onlinestore_app/core/components/buttons.dart';
import 'package:flutter_onlinestore_app/core/components/custom_text_field.dart';
import 'package:flutter_onlinestore_app/core/components/spaces.dart';
import 'package:flutter_onlinestore_app/core/extensions/context_ext.dart';
import 'package:flutter_onlinestore_app/data/datasources/region_remote_datasource.dart';
import 'package:flutter_onlinestore_app/data/models/request/address_request_model.dart';
import 'package:flutter_onlinestore_app/data/models/response/address_response_model.dart';
import 'package:flutter_onlinestore_app/presentation/address/bloc/address_bloc.dart';
import 'package:flutter_onlinestore_app/presentation/address/widgets/map_picker_widget.dart';

class AddressFormPage extends StatefulWidget {
  final Address? existing;
  const AddressFormPage({super.key, this.existing});

  @override
  State<AddressFormPage> createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _detailCtrl = TextEditingController();
  final _postalCtrl = TextEditingController();
  final _labelCtrl = TextEditingController();

  RegionItem? _province;
  RegionItem? _city;
  RegionItem? _district;
  double? _lat;
  double? _lng;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _nameCtrl.text = e.recipientName ?? '';
      _phoneCtrl.text = e.phone ?? '';
      _addressCtrl.text = e.address ?? '';
      _detailCtrl.text = e.detail ?? '';
      _postalCtrl.text = e.postalCode ?? '';
      _labelCtrl.text = e.label ?? '';
      _lat = double.tryParse(e.latitude ?? '');
      _lng = double.tryParse(e.longitude ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.existing == null ? 'Tambah Alamat' : 'Edit Alamat')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(controller: _labelCtrl, label: 'Label (Rumah/Kantor)'),
              const SpaceHeight(12),
              CustomTextField(controller: _nameCtrl, label: 'Nama Penerima',
                validator: (v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null),
              const SpaceHeight(12),
              CustomTextField(controller: _phoneCtrl, label: 'No HP',
                keyboardType: TextInputType.phone,
                validator: (v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null),
              const SpaceHeight(12),
              // RegionDropdownWidget di sini — lihat widget terpisah
              // ...
              CustomTextField(controller: _addressCtrl, label: 'Alamat Lengkap', maxLines: 2,
                validator: (v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null),
              const SpaceHeight(12),
              CustomTextField(controller: _detailCtrl, label: 'Detail (Blok/RT/RW)'),
              const SpaceHeight(12),
              CustomTextField(controller: _postalCtrl, label: 'Kode Pos',
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null),
              const SpaceHeight(16),
              const Text('Pin Lokasi di Peta', style: TextStyle(fontWeight: FontWeight.bold)),
              const SpaceHeight(8),
              MapPickerWidget(
                initialLat: _lat,
                initialLng: _lng,
                onLocationPicked: (LatLng p) async {
                  setState(() {
                    _lat = p.latitude;
                    _lng = p.longitude;
                  });
                  // Reverse geocode (optional auto-fill)
                  final r = await RegionRemoteDatasource().reverseGeocode(p.latitude, p.longitude);
                  r.fold((_) {}, (data) {
                    if (mounted && _postalCtrl.text.isEmpty) {
                      _postalCtrl.text = data.postalCode ?? '';
                    }
                  });
                },
              ),
              const SpaceHeight(24),
              BlocConsumer<AddressBloc, AddressState>(
                listener: (context, state) {
                  state.maybeWhen(
                    loaded: (_) => context.pop(),
                    error: (msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg))),
                    orElse: () {},
                  );
                },
                builder: (context, state) {
                  final loading = state.maybeWhen(loading: () => true, orElse: () => false);
                  return Button.filled(
                    onPressed: loading ? null : _submit,
                    label: loading ? 'Menyimpan...' : 'Simpan',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_province == null || _city == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih provinsi dan kota')));
      return;
    }
    final request = AddressRequestModel(
      recipientName: _nameCtrl.text,
      phone: _phoneCtrl.text,
      address: _addressCtrl.text,
      detail: _detailCtrl.text,
      province: _province!.name,
      provinceId: _province!.id,
      city: _city!.name,
      cityId: _city!.id,
      district: _district?.name,
      districtId: _district?.id,
      postalCode: _postalCtrl.text,
      latitude: _lat?.toString(),
      longitude: _lng?.toString(),
      label: _labelCtrl.text.isEmpty ? null : _labelCtrl.text,
    );
    if (widget.existing == null) {
      context.read<AddressBloc>().add(AddressEvent.createAddress(request));
    } else {
      context.read<AddressBloc>().add(AddressEvent.updateAddress(widget.existing!.id!, request));
    }
  }
}
```

> 💡 **RegionDropdownWidget**: cascade dropdown (province → city → district). Pakai 3 FutureBuilder atau widget terpisah `region_dropdown_widget.dart`. Lihat repo akhir untuk implementasi lengkap.

---

## 9. AddressListPage

`lib/presentation/address/pages/address_list_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_onlinestore_app/core/constants/colors.dart';
import 'package:flutter_onlinestore_app/core/components/buttons.dart';
import 'package:flutter_onlinestore_app/core/extensions/context_ext.dart';
import 'package:flutter_onlinestore_app/data/models/response/address_response_model.dart';
import 'package:flutter_onlinestore_app/presentation/address/bloc/address_bloc.dart';
import 'package:flutter_onlinestore_app/presentation/address/pages/address_form_page.dart';

class AddressListPage extends StatefulWidget {
  const AddressListPage({super.key});

  @override
  State<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  @override
  void initState() {
    super.initState();
    context.read<AddressBloc>().add(const AddressEvent.getAddresses());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alamat Saya')),
      body: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (list) => list.isEmpty
                ? const Center(child: Text('Belum ada alamat. Tambahkan dulu.'))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => _addressTile(list[i]),
                  ),
            error: (msg) => Center(child: Text(msg)),
            orElse: () => const SizedBox(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(const AddressFormPage()),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }

  Widget _addressTile(Address a) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: a.isDefault == true ? AppColors.primary : AppColors.divider),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(a.label ?? 'Alamat', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              if (a.isDefault == true)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('Utama', style: TextStyle(
                    fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w600)),
                ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.edit, size: 18),
                onPressed: () => context.push(AddressFormPage(existing: a)),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                onPressed: () => context.read<AddressBloc>().add(AddressEvent.deleteAddress(a.id!)),
              ),
            ],
          ),
          Text('${a.recipientName} · ${a.phone}'),
          const SizedBox(height: 4),
          Text(a.fullAddress, style: const TextStyle(color: AppColors.darkGrey)),
          if (a.isDefault != true) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.read<AddressBloc>().add(AddressEvent.setDefault(a.id!)),
              child: const Text('Jadikan Alamat Utama'),
            ),
          ],
        ],
      ),
    );
  }
}
```

---

## 10. Register di main.dart

```dart
BlocProvider(create: (_) => AddressBloc(AddressRemoteDatasource())),
```

---

## 11. Test Flow

1. Profile → "Alamat Saya" → AddressListPage muncul
2. Tap FAB "Tambah" → AddressFormPage
3. Isi semua field, tap pin di map → marker berpindah
4. Tap simpan → list update, alamat baru muncul
5. Tap "Jadikan Utama" → badge "Utama" pindah
6. Tap edit → form muncul terisi → ubah → simpan
7. Tap delete → konfirmasi dialog (optional) → hapus

✅ **Checkpoint**: CRUD alamat working, map muncul tile OpenStreetMap.

---

## ✅ Checklist Akhir Sesi 08

- [ ] AddressRequestModel + Address model
- [ ] AddressRemoteDatasource (5 method)
- [ ] RegionRemoteDatasource (Emsifa + Nominatim reverse)
- [ ] AddressBloc + freezed
- [ ] MapPickerWidget (flutter_map + geolocator)
- [ ] AddressFormPage dengan map
- [ ] AddressListPage dengan default badge
- [ ] Permission lokasi Android + iOS sudah ditambah
- [ ] Test CRUD + map picking working

---

## 🐛 Common Issues

| Error | Penyebab | Fix |
|-------|----------|-----|
| Map tile blank | TileLayer URL salah / no internet | Cek URL `https://tile.openstreetmap.org/{z}/{x}/{y}.png` |
| Geolocator throw permission | Belum minta permission | Pakai `Geolocator.requestPermission()` |
| Nominatim 403 / blocked | Default User-Agent | Set `User-Agent` custom dengan email |
| Region dropdown kosong | CORS / network error | Cek `flutter doctor`, restart app |
| AndroidManifest tidak ke-read | Belum rebuild | `flutter clean && flutter run` |

---

## 📝 Latihan Mandiri

1. Tambah **search lokasi** dengan Nominatim search (autocomplete address)
2. Tambah dialog **konfirmasi delete** sebelum hapus alamat
3. Tambah validasi kode pos minimal 5 digit
4. Tambah field **provinsi/kota/kecamatan** sebagai cascade dropdown (lihat widget `region_dropdown_widget.dart` di repo akhir)

---

## ➡️ Lanjut ke [Sesi 09 — Checkout & Shipping](./09-checkout-shipping.md)
