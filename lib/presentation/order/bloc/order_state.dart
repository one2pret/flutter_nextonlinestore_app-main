part of 'order_bloc.dart';

@freezed
sealed class OrderState with _$OrderState {
  const factory OrderState.initial() = _Initial;
  const factory OrderState.loading() = _Loading;
  const factory OrderState.listLoaded(List<Order> orders) = _ListLoaded;
  const factory OrderState.detailLoaded(Order order) = _DetailLoaded;
  const factory OrderState.actionSuccess(String message,
      {String? paymentUrl}) = _ActionSuccess;
  const factory OrderState.error(String message) = _Error;
}
