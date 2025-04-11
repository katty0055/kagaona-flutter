import 'package:flutter/material.dart';
import 'package:kgaona/helpers/dialog_helper.dart';
import 'package:kgaona/views/welcome_screen.dart';
import 'package:kgaona/views/tareas_screen.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
  });

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
        showLogoutDialog(context); // Llama al diálogo reutilizable
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
        BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Tarea'),
        BottomNavigationBarItem(icon: Icon(Icons.close), label: "Salir"),
      ],
    );
  }
}