import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/datasources/auth_remote_datasource.dart';
import '../../../data/models/request/login_request_model.dart';
import '../../../data/models/response/auth_response_model.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRemoteDatasource _datasource;

  LoginBloc(this._datasource) : super(const LoginState.initial()) {
    on<_Login>(_onLogin);
  }

  Future<void> _onLogin(_Login event, Emitter<LoginState> emit) async {
    emit(const LoginState.loading());
    final result = await _datasource.login(
      LoginRequestModel(email: event.email, password: event.password),
    );
    result.fold(
      (error) => emit(LoginState.error(error)),
      (data) => emit(LoginState.success(data)),
    );
  }
}
