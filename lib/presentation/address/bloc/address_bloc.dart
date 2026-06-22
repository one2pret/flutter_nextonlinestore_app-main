import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/datasources/address_remote_datasource.dart';
import '../../../data/models/request/address_request_model.dart';
import '../../../data/models/response/address_response_model.dart';

part 'address_event.dart';
part 'address_state.dart';
part 'address_bloc.freezed.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressRemoteDatasource _datasource;

  AddressBloc(this._datasource) : super(const AddressState.initial()) {
    on<_GetAddresses>(_onGet);
    on<_CreateAddress>(_onCreate);
    on<_UpdateAddress>(_onUpdate);
    on<_DeleteAddress>(_onDelete);
    on<_SetDefault>(_onSetDefault);
  }

  Future<void> _refetch(Emitter<AddressState> emit) async {
    final list = await _datasource.getAddresses();
    list.fold(
      (e) => emit(AddressState.error(e)),
      (data) => emit(AddressState.loaded(data.data ?? [])),
    );
  }

  Future<void> _onGet(_GetAddresses event, Emitter<AddressState> emit) async {
    emit(const AddressState.loading());
    await _refetch(emit);
  }

  Future<void> _onCreate(
      _CreateAddress event, Emitter<AddressState> emit) async {
    emit(const AddressState.loading());
    final result = await _datasource.createAddress(event.request);
    await result.fold(
      (err) async => emit(AddressState.error(err)),
      (_) async => _refetch(emit),
    );
  }

  Future<void> _onUpdate(
      _UpdateAddress event, Emitter<AddressState> emit) async {
    emit(const AddressState.loading());
    final result = await _datasource.updateAddress(event.id, event.request);
    await result.fold(
      (err) async => emit(AddressState.error(err)),
      (_) async => _refetch(emit),
    );
  }

  Future<void> _onDelete(
      _DeleteAddress event, Emitter<AddressState> emit) async {
    final result = await _datasource.deleteAddress(event.id);
    await result.fold(
      (err) async => emit(AddressState.error(err)),
      (_) async => _refetch(emit),
    );
  }

  Future<void> _onSetDefault(
      _SetDefault event, Emitter<AddressState> emit) async {
    final result = await _datasource.setDefaultAddress(event.id);
    await result.fold(
      (err) async => emit(AddressState.error(err)),
      (_) async => _refetch(emit),
    );
  }
}
