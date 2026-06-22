import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/datasources/product_remote_datasource.dart';
import '../../../data/models/response/product_response_model.dart';

part 'product_detail_event.dart';
part 'product_detail_state.dart';
part 'product_detail_bloc.freezed.dart';

class ProductDetailBloc
    extends Bloc<ProductDetailEvent, ProductDetailState> {
  final ProductRemoteDatasource _datasource;

  ProductDetailBloc(this._datasource)
      : super(const ProductDetailState.initial()) {
    on<_GetProductDetail>((event, emit) async {
      emit(const ProductDetailState.loading());
      final result = await _datasource.getProductDetail(event.id);
      result.fold(
        (err) => emit(ProductDetailState.error(err)),
        (data) => emit(ProductDetailState.loaded(data)),
      );
    });
  }
}
