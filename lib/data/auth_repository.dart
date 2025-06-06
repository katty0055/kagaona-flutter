import 'package:kgaona/api/service/auth_service.dart';
import 'package:kgaona/constants/constantes.dart';
import 'package:kgaona/data/preferencia_repository.dart';
import 'package:kgaona/data/tarea_repository.dart';
import 'package:kgaona/domain/login_request.dart';
import 'package:kgaona/domain/login_response.dart';
import 'package:kgaona/helpers/secure_storage_service.dart';
import 'package:watch_it/watch_it.dart';

class AuthRepository {
  final _authService = di<AuthService>();
  final _secureStorage = di<SecureStorageService>();
  final _tareaRepository = di<TareaRepository>();
  final preferenciaRepository = di<PreferenciaRepository>();
  Future<bool> login(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw ArgumentError(AuthConstantes.errorVacio);
      }
      preferenciaRepository.invalidarCache();
      final loginRequest = LoginRequest(username: email, password: password);
      final LoginResponse response = await _authService.login(loginRequest);
      await _secureStorage.saveJwt(response.sessionToken);
      await _secureStorage.saveUserEmail(email);
      await preferenciaRepository.cargarDatos();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    preferenciaRepository.invalidarCache();
    _tareaRepository.limpiarCache();
    await _secureStorage.clearJwt();
    await _secureStorage.clearUserEmail();
  }

  Future<String?> getAuthToken() async {
    return await _secureStorage.getJwt();
  }
}
