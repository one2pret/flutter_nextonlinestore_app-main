import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/datasources/cart_remote_datasource.dart';
import '../../../data/models/request/cart_request_model.dart';
import '../../../data/models/response/cart_response_model.dart';

part 'cart_event.dart';
part 'cart_state.dart';
part 'cart_bloc.freezed.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRemoteDatasource _datasource;

  CartBloc(this._datasource) : super(const CartState.initial()) {
    on<_GetCart>(_onGetCart);
    on<_AddToCart>(_onAddToCart);
    on<_UpdateCartItem>(_onUpdateCartItem);
    on<_RemoveCartItem>(_onRemoveCartItem);
  }

  Future<void> _onGetCart(_GetCart event, Emitter<CartState> emit) async {
    emit(const CartState.loading());
    final result = await _datasource.getCart();
    result.fold(
      (err) => emit(CartState.error(err)),
      (data) => emit(CartState.loaded(data.data ?? [])),
    );
  }

  Future<void> _onAddToCart(_AddToCart event, Emitter<CartState> emit) async {
    emit(const CartState.loading());
    final result = await _datasource.addToCart(
      CartRequestModel(productId: event.productId, quantity: event.quantity),
    );
    await result.fold(
      (err) async => emit(CartState.error(err)),
      (_) async {
        final cartResult = await _datasource.getCart();
        cartResult.fold(
          (err) => emit(CartState.error(err)),
          (data) => emit(CartState.loaded(data.data ?? [])),
        );
      },
    );
  }

  Future<void> _onUpdateCartItem(
      _UpdateCartItem event, Emitter<CartState> emit) async {
    final currentItems =
        state is _Loaded ? (state as _Loaded).items : <CartItem>[];
    emit(CartState.loaded(
      currentItems.map((item) {
        if (item.id == event.id) {
          return CartItem(
            id: item.id,
            userId: item.userId,
            productId: item.productId,
            quantity: event.quantity,
            createdAt: item.createdAt,
            updatedAt: item.updatedAt,
            product: item.product,
          );
        }
        return item;
      }).toList(),
    ));

    final result = await _datasource.updateCartItem(event.id, event.quantity);
    await result.fold(
      (err) async {
        final cartResult = await _datasource.getCart();
        cartResult.fold(
          (e) => emit(CartState.error(e)),
          (data) => emit(CartState.loaded(data.data ?? [])),
        );
      },
      (_) async {},
    );
  }

  Future<void> _onRemoveCartItem(
      _RemoveCartItem event, Emitter<CartState> emit) async {
    final currentItems =
        state is _Loaded ? (state as _Loaded).items : <CartItem>[];
    emit(CartState.loaded(
      currentItems.where((item) => item.id != event.id).toList(),
    ));

    final result = await _datasource.removeCartItem(event.id);
    await result.fold(
      (err) async {
        final cartResult = await _datasource.getCart();
        cartResult.fold(
          (e) => emit(CartState.error(e)),
          (data) => emit(CartState.loaded(data.data ?? [])),
        );
      },
      (_) async {},
    );
  }
}
