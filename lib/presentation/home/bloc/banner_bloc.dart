import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/datasources/banner_remote_datasource.dart';
import '../../../data/models/response/banner_response_model.dart';

part 'banner_event.dart';
part 'banner_state.dart';
part 'banner_bloc.freezed.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  final BannerRemoteDatasource _datasource;

  BannerBloc(this._datasource) : super(const BannerState.initial()) {
    on<_GetBanners>((event, emit) async {
      emit(const BannerState.loading());
      final result = await _datasource.getBanners();
      result.fold(
        (err) => emit(BannerState.error(err)),
        (data) => emit(BannerState.loaded(data)),
      );
    });
  }
}
