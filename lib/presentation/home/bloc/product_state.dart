part of 'product_bloc.dart';

@freezed
sealed class ProductState with _$ProductState {
  const factory ProductState.initial() = _Initial;
  const factory ProductState.loading() = _Loading;
  const factory ProductState.loaded(
    List<Product> products,
    PaginationMeta? meta,
  ) = _Loaded;
  const factory ProductState.error(String message) = _Error;
}
