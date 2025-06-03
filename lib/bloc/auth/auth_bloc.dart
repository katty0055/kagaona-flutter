import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgaona/data/auth_repository.dart';
import 'package:kgaona/bloc/auth/auth_event.dart';
import 'package:kgaona/bloc/auth/auth_state.dart';
import 'package:kgaona/data/preferencia_repository.dart';
import 'package:kgaona/exceptions/api_exception.dart';
import 'package:watch_it/watch_it.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository= di<AuthRepository>(); // Obtenemos el repositorio del locator

  AuthBloc(): super(const AuthInitial()) {
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(AuthFailure(ApiException('El usuario y la contraseña son obligatorios')));
        return;
      }
      
      final success = await _authRepository.login(
        event.email,
        event.password,
      );
      if (success) {
        emit(const AuthAuthenticated());
      } else {
        emit(AuthFailure(ApiException('Credenciales inválidas')));
      }
    } catch (e) {
      emit( AuthFailure(ApiException('Error al iniciar sesión')));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _authRepository.logout();
      di<PreferenciaRepository>().invalidarCache();      
      emit(const AuthInitial());
    } catch (e) {
      emit(AuthFailure(ApiException('Error al cerrar sesión')));
    }
  }

  void _onTogglePasswordVisibility(
    TogglePasswordVisibility event,
    Emitter<AuthState> emit,
  ) {
    // Cambiamos el estado actual manteniendo su tipo pero invirtiendo passwordVisible
    emit(state.copyWithPasswordVisibility(!state.passwordVisible));
  }
}