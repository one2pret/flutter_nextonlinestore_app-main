import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/services/push_notification_service.dart';
import '../../../data/datasources/auth_local_datasource.dart';
import '../../../data/datasources/auth_remote_datasource.dart';
import '../../../data/models/response/auth_response_model.dart';

part 'profile_event.dart';
part 'profile_state.dart';
part 'profile_bloc.freezed.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRemoteDatasource _remote;
  final AuthLocalDatasource _local;

  ProfileBloc(this._remote, this._local)
      : super(const ProfileState.initial()) {
    on<_GetProfile>(_onGetProfile);
    on<_UpdateProfile>(_onUpdateProfile);
    on<_Logout>(_onLogout);
  }

  Future<void> _onGetProfile(
      _GetProfile event, Emitter<ProfileState> emit) async {
    emit(const ProfileState.loading());
    final result = await _remote.getProfile();
    await result.fold(
      (error) async {
        final cached = await _local.getUser();
        if (cached != null) {
          emit(ProfileState.loaded(User.fromJson(cached)));
        } else {
          emit(ProfileState.error(error));
        }
      },
      (user) async {
        await _local.saveUser(user.toJson());
        emit(ProfileState.loaded(user));
      },
    );
  }

  Future<void> _onUpdateProfile(
      _UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(const ProfileState.loading());
    final result =
        await _remote.updateProfile(name: event.name, phone: event.phone);
    await result.fold(
      (error) async => emit(ProfileState.error(error)),
      (user) async {
        await _local.saveUser(user.toJson());
        emit(ProfileState.updated(user));
      },
    );
  }

  Future<void> _onLogout(_Logout event, Emitter<ProfileState> emit) async {
    await PushNotificationService.instance.clearTokenBeforeLogout();
    await _local.clearAll();
    emit(const ProfileState.loggedOut());
  }
}
