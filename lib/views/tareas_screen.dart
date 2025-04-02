import 'package:flutter/material.dart';
import 'package:kgaona/views/login_screen.dart';
import 'package:kgaona/views/welcome_screen.dart';

class TareasScreen extends StatefulWidget {
  const TareasScreen({super.key});

  @override
  _TareasScreenState createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  int _selectedIndex = 0; // Índice del elemento seleccionado en el navbar

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Lógica para manejar la navegación según el índice seleccionado
    switch (index) {
      case 0: // Inicio
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
        break;
      case 1: // Añadir Tarea
        // Ya estás en TareasScreen, no necesitas navegar
        break;
      case 2: // Salir
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  LoginScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tareas')),
      body:  Center(
        child: Text(
          'Tareas',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Índice del elemento seleccionado
        onTap: _onItemTapped, // Maneja el evento de selección
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Añadir Tarea'),
          BottomNavigationBarItem(icon: Icon(Icons.close), label: "Salirr"),
        ],
      ),
    );
  }
}
