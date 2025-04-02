import 'package:flutter/material.dart';
import 'views/login_screen.dart'; // Importa la pantalla de login

void main() {
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
      home: LoginScreen(), // Establece LoginScreen como la pantalla inicial
    );
  }
}
