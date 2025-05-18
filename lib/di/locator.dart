import 'package:kgaona/data/auth_repository.dart';
import 'package:kgaona/data/categoria_repository.dart';
import 'package:kgaona/data/noticia_repository.dart';
import 'package:kgaona/data/preferencia_repository.dart';
import 'package:kgaona/helpers/connectivity_service.dart';
import 'package:kgaona/helpers/global_snack_service.dart';
import 'package:kgaona/helpers/secure_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';

Future<void> initLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  di.registerSingleton<SharedPreferences>(sharedPreferences);
  di.registerSingleton<CategoriaRepository>(CategoriaRepository());
  di.registerLazySingleton<PreferenciaRepository>(() => PreferenciaRepository());
  di.registerLazySingleton<NoticiaRepository>(() => NoticiaRepository());
  di.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  di.registerLazySingleton<AuthRepository>(() => AuthRepository());
  di.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  
  // Registrar el servicio global de SnackBar como singleton
  // No es necesario crear una nueva instancia ya que usamos globalSnackService
  // que ya es un singleton, pero lo registramos para consistencia
  di.registerLazySingleton(() => globalSnackService);
}