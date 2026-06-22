import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/datasources/order_remote_datasource.dart';
import '../../../data/models/request/order_request_model.dart';
import '../../../data/models/response/order_response_model.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';
part 'checkout_bloc.freezed.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final OrderRemoteDatasource _datasource;

  CheckoutBloc(this._datasource) : super(const CheckoutState.initial()) {
    on<_CreateOrder>((event, emit) async {
      emit(const CheckoutState.loading());
      final result = await _datasource.createOrder(event.request);
      result.fold(
        (err) => emit(CheckoutState.error(err)),
        (data) => emit(CheckoutState.success(
          data.data ?? Order(),
          data.paymentUrl,
        )),
      );
    });
  }
}
