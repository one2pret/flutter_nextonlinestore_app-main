import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/datasources/region_remote_datasource.dart';

class RegionDropdownWidget extends StatefulWidget {
  final RegionItem? initialProvince;
  final RegionItem? initialCity;
  final RegionItem? initialDistrict;
  final void Function(RegionItem? province, RegionItem? city,
      RegionItem? district) onChanged;

  const RegionDropdownWidget({
    super.key,
    this.initialProvince,
    this.initialCity,
    this.initialDistrict,
    required this.onChanged,
  });

  @override
  State<RegionDropdownWidget> createState() => _RegionDropdownWidgetState();
}

class _RegionDropdownWidgetState extends State<RegionDropdownWidget> {
  final _ds = RegionRemoteDatasource();

  List<RegionItem> _provinces = [];
  List<RegionItem> _cities = [];
  List<RegionItem> _districts = [];

  RegionItem? _province;
  RegionItem? _city;
  RegionItem? _district;

  bool _loadingProvinces = true;
  bool _loadingCities = false;
  bool _loadingDistricts = false;

  @override
  void initState() {
    super.initState();
    _province = widget.initialProvince;
    _city = widget.initialCity;
    _district = widget.initialDistrict;
    _loadProvinces();
  }

  Future<void> _loadProvinces() async {
    final result = await _ds.getProvinces();
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _loadingProvinces = false),
      (list) {
        setState(() {
          _provinces = list;
          _loadingProvinces = false;
        });
        if (_province != null) _loadCities(_province!.id);
      },
    );
  }

  Future<void> _loadCities(String provinceId) async {
    setState(() => _loadingCities = true);
    final result = await _ds.getCities(provinceId);
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _loadingCities = false),
      (list) {
        setState(() {
          _cities = list;
          _loadingCities = false;
        });
        if (_city != null) _loadDistricts(_city!.id);
      },
    );
  }

  Future<void> _loadDistricts(String cityId) async {
    setState(() => _loadingDistricts = true);
    final result = await _ds.getDistricts(cityId);
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _loadingDistricts = false),
      (list) {
        setState(() {
          _districts = list;
          _loadingDistricts = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dropdown(
          label: 'Provinsi',
          value: _province,
          items: _provinces,
          loading: _loadingProvinces,
          onChanged: (v) {
            setState(() {
              _province = v;
              _city = null;
              _district = null;
              _cities = [];
              _districts = [];
            });
            widget.onChanged(_province, _city, _district);
            if (v != null) _loadCities(v.id);
          },
        ),
        const SizedBox(height: 12),
        _dropdown(
          label: 'Kota / Kabupaten',
          value: _city,
          items: _cities,
          loading: _loadingCities,
          disabled: _province == null,
          onChanged: (v) {
            setState(() {
              _city = v;
              _district = null;
              _districts = [];
            });
            widget.onChanged(_province, _city, _district);
            if (v != null) _loadDistricts(v.id);
          },
        ),
        const SizedBox(height: 12),
        _dropdown(
          label: 'Kecamatan',
          value: _district,
          items: _districts,
          loading: _loadingDistricts,
          disabled: _city == null,
          onChanged: (v) {
            setState(() => _district = v);
            widget.onChanged(_province, _city, _district);
          },
        ),
      ],
    );
  }

  Widget _dropdown({
    required String label,
    required RegionItem? value,
    required List<RegionItem> items,
    required bool loading,
    bool disabled = false,
    required ValueChanged<RegionItem?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.black)),
        const SizedBox(height: 8),
        InputDecorator(
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
          ),
          child: loading
              ? const SizedBox(
                  height: 32,
                  child: Center(
                      child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2))),
                )
              : DropdownButtonHideUnderline(
                  child: DropdownButton<RegionItem>(
                    isExpanded: true,
                    value: items.contains(value) ? value : null,
                    hint: Text(
                      disabled ? 'Pilih sebelumnya dulu' : 'Pilih $label',
                      style: const TextStyle(color: AppColors.grey),
                    ),
                    items: items
                        .map((r) => DropdownMenuItem(
                              value: r,
                              child: Text(r.name,
                                  overflow: TextOverflow.ellipsis),
                            ))
                        .toList(),
                    onChanged: disabled ? null : onChanged,
                  ),
                ),
        ),
      ],
    );
  }
}
