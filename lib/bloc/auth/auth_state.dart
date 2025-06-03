import 'package:equatable/equatable.dart';
import 'package:kgaona/exceptions/api_exception.dart';

abstract class AuthState extends Equatable {
  // Propiedad para la visibilidad de la contraseña, por defecto falso
  final bool passwordVisible;
  
  // Constructor con parámetro opcional
  const AuthState({this.passwordVisible = false});
  
  // Método para crear una copia del estado con visibilidad cambiada
  // Cada subclase lo sobreescribirá para crear una instancia de su propio tipo
  AuthState copyWithPasswordVisibility(bool visible);
  
  @override
  List<Object> get props => [passwordVisible];
}

class AuthInitial extends AuthState {
  const AuthInitial({super.passwordVisible});
  
  @override
  AuthInitial copyWithPasswordVisibility(bool visible) => 
      AuthInitial(passwordVisible: visible);
}

class AuthLoading extends AuthState {
  const AuthLoading({super.passwordVisible});
  
  @override
  AuthLoading copyWithPasswordVisibility(bool visible) => 
      AuthLoading(passwordVisible: visible);
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({super.passwordVisible});
  
  @override
  AuthAuthenticated copyWithPasswordVisibility(bool visible) => 
      AuthAuthenticated(passwordVisible: visible);
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated({super.passwordVisible});
  
  @override
  AuthUnauthenticated copyWithPasswordVisibility(bool visible) => 
      AuthUnauthenticated(passwordVisible: visible);
}

class AuthFailure extends AuthState {
  final ApiException error;

  const AuthFailure(this.error, {super.passwordVisible});

  @override
  List<Object> get props => [error, passwordVisible];
  
  @override
  AuthFailure copyWithPasswordVisibility(bool visible) => 
      AuthFailure(error, passwordVisible: visible);
}