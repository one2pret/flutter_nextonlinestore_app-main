part of 'cart_bloc.dart';

@freezed
sealed class CartEvent with _$CartEvent {
  const factory CartEvent.getCart() = _GetCart;
  const factory CartEvent.addToCart({
    required int productId,
    @Default(1) int quantity,
  }) = _AddToCart;
  const factory CartEvent.updateCartItem({
    required int id,
    required int quantity,
  }) = _UpdateCartItem;
  const factory CartEvent.removeCartItem(int id) = _RemoveCartItem;
}
