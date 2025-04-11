import 'package:flutter/material.dart';
import 'package:kgaona/components/custom_bottom_navigation_bar.dart';
import 'package:kgaona/components/side_menu.dart';
import 'package:kgaona/constants.dart';
import 'package:kgaona/views/game_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  final int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(titleApp), // Usa el título definido en constants.dart
        centerTitle: true,
      ),
      drawer: const SideMenu(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              welcomeMessage, // Muestra el mensaje de bienvenida
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GameScreen()),
                );
              },
               style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Cambia el color del botón a azul
              ),
              child: const Text(startGame), // Texto del botón definido en constants.dart
            ),
          ],
        ),
      ),
      bottomNavigationBar:  CustomBottomNavigationBar(selectedIndex: _selectedIndex),
    );
  }
}