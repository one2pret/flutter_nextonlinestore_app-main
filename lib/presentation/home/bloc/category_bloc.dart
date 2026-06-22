import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/datasources/category_remote_datasource.dart';
import '../../../data/models/response/product_response_model.dart';

part 'category_event.dart';
part 'category_state.dart';
part 'category_bloc.freezed.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRemoteDatasource _datasource;

  CategoryBloc(this._datasource) : super(const CategoryState.initial()) {
    on<_GetCategories>((event, emit) async {
      emit(const CategoryState.loading());
      final result = await _datasource.getCategories();
      result.fold(
        (err) => emit(CategoryState.error(err)),
        (data) => emit(CategoryState.loaded(data)),
      );
    });
  }
}
