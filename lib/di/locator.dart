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
  final sharedPreferences = await SharedPreferences.getInstance();
  di.registerSingleton<SharedPreferences>(sharedPreferences);
  di.registerSingleton<CategoriaRepository>(CategoriaRepository());
  di.registerLazySingleton<PreferenciaRepository>(() => PreferenciaRepository());  
  di.registerLazySingleton<NoticiaRepository>(() => NoticiaRepository());
  di.registerLazySingleton<ComentarioRepository>(() => ComentarioRepository());
  di.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  di.registerLazySingleton<AuthRepository>(() => AuthRepository());
  di.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  di.registerSingleton<ReporteRepository>(ReporteRepository());
  di.registerFactory<ReporteBloc>(() => ReporteBloc());
  di.registerSingleton<SharedPreferencesService>(SharedPreferencesService());
  di.registerSingleton<TareaService>(TareaService());
  di.registerSingleton<TareasRepository>(TareasRepository());
}