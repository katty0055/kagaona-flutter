import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kgaona/di/locator.dart';
import 'package:kgaona/views/login_screen.dart'; 

void main() async {
  await dotenv.load(fileName: ".env");
  await initLocator();// Carga el archivo .env
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
      ),
      home: LoginScreen(),
    );
  }
}
