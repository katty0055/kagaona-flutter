import 'package:flutter/material.dart';
import 'package:kgaona/views/contador_screen.dart';
import 'package:kgaona/views/mi_app_screen.dart';
import 'package:kgaona/views/welcome_screen.dart';
import 'package:kgaona/views/tareas_screen.dart';
import 'package:kgaona/views/login_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 80, // To change the height of DrawerHeader
            child: DrawerHeader(
              decoration:  BoxDecoration(color: Color.fromARGB(255, 217, 162, 180)),
              margin: EdgeInsets.zero, // Elimina el margen predeterminado
              padding: EdgeInsets.symmetric(horizontal: 18.0), // Elimina el padding interno
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Menú ',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.task),
            title: const Text('Tareas'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TareasScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.apps), // Ícono para la nueva opción
            title: const Text('Mi App'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MiAppScreen()), // Navega a MiAppScreen
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.numbers), // Ícono para el contador
            title: const Text('Contador'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ContadorScreen(title: 'Contador'),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Confirmar'),
                    content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Cierra el diálogo
                        },
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Cierra el diálogo
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                        child: const Text('Cerrar Sesión'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}