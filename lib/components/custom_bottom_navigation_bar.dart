import 'package:flutter/material.dart';
import 'package:kgaona/views/welcome_screen.dart';
import 'package:kgaona/views/tareas_screen.dart';
import 'package:kgaona/views/login_screen.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
  }) : super(key: key);

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0: // Inicio
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
        break;
      case 1: // Añadir Tarea
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TareasScreen()),
        );
        break;
      case 2: // Salir
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) => _onItemTapped(context, index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Añadir Tarea'),
        BottomNavigationBarItem(icon: Icon(Icons.close), label: "Salir"),
      ],
    );
  }
}