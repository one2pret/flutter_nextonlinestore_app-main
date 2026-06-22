import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/datasources/shipping_remote_datasource.dart';
import '../../../data/models/response/shipping_rate_response_model.dart';

part 'shipping_event.dart';
part 'shipping_state.dart';
part 'shipping_bloc.freezed.dart';

class ShippingBloc extends Bloc<ShippingEvent, ShippingState> {
  final ShippingRemoteDatasource _datasource;

  ShippingBloc(this._datasource) : super(const ShippingState.initial()) {
    on<_CalculateRates>((event, emit) async {
      emit(const ShippingState.loading());
      final result = await _datasource.calculateRates(event.addressId);
      result.fold(
        (err) => emit(ShippingState.error(err)),
        (data) => emit(ShippingState.loaded(data.data ?? ShippingRateData())),
      );
    });
  }
}
