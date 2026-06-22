import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/datasources/order_remote_datasource.dart';
import '../../../data/models/response/order_response_model.dart';

part 'order_event.dart';
part 'order_state.dart';
part 'order_bloc.freezed.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRemoteDatasource _datasource;

  OrderBloc(this._datasource) : super(const OrderState.initial()) {
    on<_GetOrders>((event, emit) async {
      emit(const OrderState.loading());
      final result = await _datasource.getOrders(status: event.status);
      result.fold(
        (err) => emit(OrderState.error(err)),
        (data) => emit(OrderState.listLoaded(data.data ?? [])),
      );
    });

    on<_GetOrderDetail>((event, emit) async {
      emit(const OrderState.loading());
      final result = await _datasource.getOrderDetail(event.id);
      result.fold(
        (err) => emit(OrderState.error(err)),
        (data) => emit(OrderState.detailLoaded(data)),
      );
    });

    on<_CancelOrder>((event, emit) async {
      final result =
          await _datasource.cancelOrder(event.id, reason: event.reason);
      result.fold(
        (err) => emit(OrderState.error(err)),
        (msg) => emit(OrderState.actionSuccess(msg)),
      );
    });

    on<_RepayOrder>((event, emit) async {
      final result = await _datasource.repayOrder(event.id);
      result.fold(
        (err) => emit(OrderState.error(err)),
        (url) => emit(
          OrderState.actionSuccess('Membuka ulang pembayaran',
              paymentUrl: url),
        ),
      );
    });
  }
}
