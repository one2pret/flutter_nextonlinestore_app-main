part of 'product_detail_bloc.dart';

@freezed
sealed class ProductDetailEvent with _$ProductDetailEvent {
  const factory ProductDetailEvent.getProductDetail(int id) =
      _GetProductDetail;
}
