import 'package:flutter/foundation.dart';

@immutable
class Address {
  const Address({
    required this.id,
    required this.label,
    required this.name,
    required this.phone,
    required this.detail,
    required this.city,
    required this.postal,
    this.isDefault = false,
  });

  final String id;
  final String label;
  final String name;
  final String phone;
  final String detail;
  final String city;
  final String postal;
  final bool isDefault;

  String get fullAddress => '$detail, $city $postal';

  Address copyWith({
    String? label,
    String? name,
    String? phone,
    String? detail,
    String? city,
    String? postal,
    bool? isDefault,
  }) {
    return Address(
      id: id,
      label: label ?? this.label,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      detail: detail ?? this.detail,
      city: city ?? this.city,
      postal: postal ?? this.postal,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

class AddressStore {
  AddressStore._();
  static final AddressStore instance = AddressStore._();

  final List<Address> _items = [
    const Address(
      id: 'a1',
      label: 'Home',
      name: 'John Doe',
      phone: '+62 812-3456-7890',
      detail: 'Jl. Sudirman No. 21, RT 03/RW 05, Kebayoran Baru',
      city: 'Jakarta Selatan',
      postal: '12190',
      isDefault: true,
    ),
    const Address(
      id: 'a2',
      label: 'Office',
      name: 'John Doe',
      phone: '+62 812-3456-7890',
      detail: 'Menara BCA Lt. 25, Jl. M.H. Thamrin No. 1',
      city: 'Jakarta Pusat',
      postal: '10310',
    ),
  ];

  List<Address> get items => List.unmodifiable(_items);

  Address get selected =>
      _items.firstWhere((e) => e.isDefault, orElse: () => _items.first);

  void setDefault(String id) {
    for (var i = 0; i < _items.length; i++) {
      _items[i] = _items[i].copyWith(isDefault: _items[i].id == id);
    }
  }

  void upsert(Address a) {
    final idx = _items.indexWhere((e) => e.id == a.id);
    if (a.isDefault) {
      for (var i = 0; i < _items.length; i++) {
        _items[i] = _items[i].copyWith(isDefault: false);
      }
    }
    if (idx == -1) {
      _items.add(a);
    } else {
      _items[idx] = a;
    }
  }

  String nextId() => 'a${_items.length + 1}-${DateTime.now().millisecondsSinceEpoch}';
}
