part of 'order_bloc.dart';

@freezed
sealed class OrderEvent with _$OrderEvent {
  const factory OrderEvent.getOrders({String? status}) = _GetOrders;
  const factory OrderEvent.getOrderDetail(int id) = _GetOrderDetail;
  const factory OrderEvent.cancelOrder(int id, {String? reason}) =
      _CancelOrder;
  const factory OrderEvent.repayOrder(int id) = _RepayOrder;
}
