import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/datasources/product_remote_datasource.dart';
import '../../../data/models/response/product_response_model.dart';

part 'product_event.dart';
part 'product_state.dart';
part 'product_bloc.freezed.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRemoteDatasource _datasource;

  ProductBloc(this._datasource) : super(const ProductState.initial()) {
    on<_GetProducts>(_onGetProducts);
  }

  Future<void> _onGetProducts(
      _GetProducts event, Emitter<ProductState> emit) async {
    emit(const ProductState.loading());
    final result = await _datasource.getProducts(
      category: event.category,
      search: event.search,
      featured: event.featured,
      page: event.page,
      limit: event.limit,
    );
    result.fold(
      (err) => emit(ProductState.error(err)),
      (data) => emit(ProductState.loaded(data.data ?? [], data.meta)),
    );
  }
}
