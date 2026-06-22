part of 'banner_bloc.dart';

@freezed
sealed class BannerState with _$BannerState {
  const factory BannerState.initial() = _Initial;
  const factory BannerState.loading() = _Loading;
  const factory BannerState.loaded(List<Banner> banners) = _Loaded;
  const factory BannerState.error(String message) = _Error;
}
