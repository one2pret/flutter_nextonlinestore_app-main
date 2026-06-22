import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/components/buttons.dart';
import '../../../core/components/custom_text_field.dart';
import '../../../core/components/spaces.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../data/datasources/region_remote_datasource.dart';
import '../../../data/models/request/address_request_model.dart';
import '../../../data/models/response/address_response_model.dart';
import '../bloc/address_bloc.dart';
import '../widgets/map_picker_widget.dart';
import '../widgets/region_dropdown_widget.dart';

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
  bool _submitting = false;

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
      if (e.provinceId != null && e.province != null) {
        _province = RegionItem(id: e.provinceId!, name: e.province!);
      }
      if (e.cityId != null && e.city != null) {
        _city = RegionItem(id: e.cityId!, name: e.city!);
      }
      if (e.districtId != null && e.district != null) {
        _district = RegionItem(id: e.districtId!, name: e.district!);
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _detailCtrl.dispose();
    _postalCtrl.dispose();
    _labelCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_province == null || _city == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih provinsi dan kota')),
      );
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
    _submitting = true;
    if (widget.existing == null) {
      context.read<AddressBloc>().add(AddressEvent.createAddress(request));
    } else {
      context
          .read<AddressBloc>()
          .add(AddressEvent.updateAddress(widget.existing!.id!, request));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? 'Tambah Alamat' : 'Edit Alamat'),
      ),
      body: BlocListener<AddressBloc, AddressState>(
        listener: (context, state) {
          state.maybeWhen(
            loaded: (_) {
              if (!_submitting) return;
              _submitting = false;
              context.pop();
            },
            error: (msg) {
              _submitting = false;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(msg)),
              );
            },
            orElse: () {},
          );
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                    controller: _labelCtrl, label: 'Label (Rumah/Kantor)'),
                const SpaceHeight(12),
                CustomTextField(
                  controller: _nameCtrl,
                  label: 'Nama Penerima',
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Wajib diisi' : null,
                ),
                const SpaceHeight(12),
                CustomTextField(
                  controller: _phoneCtrl,
                  label: 'No HP',
                  keyboardType: TextInputType.phone,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Wajib diisi' : null,
                ),
                const SpaceHeight(12),
                RegionDropdownWidget(
                  initialProvince: _province,
                  initialCity: _city,
                  initialDistrict: _district,
                  onChanged: (p, c, d) {
                    setState(() {
                      _province = p;
                      _city = c;
                      _district = d;
                    });
                  },
                ),
                const SpaceHeight(12),
                CustomTextField(
                  controller: _addressCtrl,
                  label: 'Alamat Lengkap',
                  maxLines: 2,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Wajib diisi' : null,
                ),
                const SpaceHeight(12),
                CustomTextField(
                    controller: _detailCtrl, label: 'Detail (Blok/RT/RW)'),
                const SpaceHeight(12),
                CustomTextField(
                  controller: _postalCtrl,
                  label: 'Kode Pos',
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Wajib diisi' : null,
                ),
                const SpaceHeight(16),
                const Text('Pin Lokasi di Peta',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SpaceHeight(8),
                MapPickerWidget(
                  initialLat: _lat,
                  initialLng: _lng,
                  onLocationPicked: (LatLng p) async {
                    setState(() {
                      _lat = p.latitude;
                      _lng = p.longitude;
                    });
                    final r = await RegionRemoteDatasource()
                        .reverseGeocode(p.latitude, p.longitude);
                    r.fold((_) {}, (data) {
                      if (!mounted) return;
                      if (_postalCtrl.text.isEmpty &&
                          data.postalCode != null) {
                        _postalCtrl.text = data.postalCode!;
                      }
                    });
                  },
                ),
                const SpaceHeight(24),
                BlocBuilder<AddressBloc, AddressState>(
                  builder: (context, state) {
                    final loading = state.maybeWhen(
                        loading: () => true, orElse: () => false);
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
      ),
    );
  }
}
