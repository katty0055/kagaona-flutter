import 'package:kgaona/api/service/auth_service.dart';
import 'package:kgaona/api/service/categoria_service.dart';
import 'package:kgaona/api/service/comentario_service.dart';
import 'package:kgaona/api/service/noticia_service.dart';
import 'package:kgaona/api/service/preferencia_service.dart';
import 'package:kgaona/api/service/reporte_service.dart';
import 'package:kgaona/api/service/tarea_service.dart';
import 'package:kgaona/bloc/reporte/reporte_bloc.dart';
import 'package:kgaona/data/auth_repository.dart';
import 'package:kgaona/data/categoria_repository.dart';
import 'package:kgaona/data/comentario_repository.dart';
import 'package:kgaona/data/noticia_repository.dart';
import 'package:kgaona/data/preferencia_repository.dart';
import 'package:kgaona/data/reporte_repository.dart';
import 'package:kgaona/data/tarea_repository.dart';
import 'package:kgaona/helpers/connectivity_service.dart';
import 'package:kgaona/helpers/secure_storage_service.dart';
import 'package:kgaona/helpers/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';

Future<void> initLocator() async {
  // Registrar primero los servicios básicos
  final sharedPreferences = await SharedPreferences.getInstance();
  di.registerSingleton<SharedPreferences>(sharedPreferences);
  di.registerLazySingleton<SharedPreferencesService>(
    () => SharedPreferencesService(),
  );
  di.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  di.registerLazySingleton<ConnectivityService>(() => ConnectivityService());

  // Servicios de API
  di.registerLazySingleton<TareaService>(() => TareaService());
  di.registerLazySingleton<ComentarioService>(() => ComentarioService());
  di.registerLazySingleton<NoticiaService>(() => NoticiaService());
  di.registerLazySingleton<AuthService>(() => AuthService());
  di.registerLazySingleton<ReporteService>(() => ReporteService());
  di.registerLazySingleton<CategoriaService>(() => CategoriaService());
  di.registerLazySingleton<PreferenciaService>(() => PreferenciaService());

  // Repositorios
  di.registerSingleton<CategoriaRepository>(CategoriaRepository());
  di.registerLazySingleton<PreferenciaRepository>(
    () => PreferenciaRepository(),
  );
  di.registerLazySingleton<NoticiaRepository>(() => NoticiaRepository());
  di.registerLazySingleton<ComentarioRepository>(() => ComentarioRepository());
  di.registerLazySingleton<AuthRepository>(() => AuthRepository());
  di.registerSingleton<ReporteRepository>(ReporteRepository());
  di.registerLazySingleton<TareaRepository>(() => TareaRepository());

  // BLoCs
  di.registerFactory<ReporteBloc>(() => ReporteBloc());
}
