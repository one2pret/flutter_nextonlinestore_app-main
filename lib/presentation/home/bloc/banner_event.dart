part of 'banner_bloc.dart';

@freezed
sealed class BannerEvent with _$BannerEvent {
  const factory BannerEvent.getBanners() = _GetBanners;
}
