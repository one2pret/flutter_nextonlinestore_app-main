part of 'product_bloc.dart';

@freezed
sealed class ProductEvent with _$ProductEvent {
  const factory ProductEvent.getProducts({
    String? category,
    String? search,
    bool? featured,
    @Default(1) int page,
    @Default(10) int limit,
  }) = _GetProducts;
}
