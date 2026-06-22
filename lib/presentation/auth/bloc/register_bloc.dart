import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/datasources/auth_remote_datasource.dart';
import '../../../data/models/request/register_request_model.dart';

part 'register_event.dart';
part 'register_state.dart';
part 'register_bloc.freezed.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRemoteDatasource _datasource;

  RegisterBloc(this._datasource) : super(const RegisterState.initial()) {
    on<_Register>(_onRegister);
  }

  Future<void> _onRegister(
      _Register event, Emitter<RegisterState> emit) async {
    emit(const RegisterState.loading());
    final result = await _datasource.register(
      RegisterRequestModel(
        name: event.name,
        email: event.email,
        phone: event.phone,
        password: event.password,
      ),
    );
    result.fold(
      (error) => emit(RegisterState.error(error)),
      (message) => emit(RegisterState.success(message)),
    );
  }
}
