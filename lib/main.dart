import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kgaona/di/locator.dart';
import 'package:kgaona/bloc/contador/contador_bloc.dart';
import 'package:kgaona/helpers/secure_storage_service.dart';
import 'package:kgaona/views/login_screen.dart';
import 'package:watch_it/watch_it.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await initLocator();// Carga el archivo .env
  
  // Eliminar cualquier token guardado para forzar el inicio de sesión
  final secureStorage = di<SecureStorageService>();
  await secureStorage.clearJwt();
  await secureStorage.clearUserEmail();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ContadorBloc>(
          create: (context) => ContadorBloc(),
        ),
        // Otros BLoCs aquí...
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        ),
        home: LoginScreen(),
      ),
    );
  }
}
