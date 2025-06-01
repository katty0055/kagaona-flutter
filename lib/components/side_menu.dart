import 'package:flutter/material.dart';
import 'package:kgaona/helpers/dialog_helper.dart';
import 'package:kgaona/views/acerca_screen.dart';
import 'package:kgaona/views/contador_screen.dart';
import 'package:kgaona/views/mi_app_screen.dart';
import 'package:kgaona/views/noticia_screen.dart';
import 'package:kgaona/views/quote_screen.dart';
import 'package:kgaona/views/start_screen.dart';
import 'package:kgaona/views/welcome_screen.dart';
import 'package:kgaona/views/tarea_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Drawer(
      backgroundColor: theme.colorScheme.primary,
            child: Column(
        children: [
          // Header que simula el AppBar
          Container(
            height: AppBar().preferredSize.height + MediaQuery.of(context).padding.top,
            width: double.infinity,
            color: theme.colorScheme.primary,  // Mismo color que el AppBar
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Text(
                  'Menú',
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary, // Color del texto
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ),
          
          // Lista de opciones del menú
          Expanded(
      child: ListView(
        padding: EdgeInsets.zero, // Elimina el padding predeterminado
        children: [
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
            leading: const Icon(Icons.bar_chart),
            title: const Text('Cotizaciones'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const QuoteScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.task),
            title: const Text('Tareas'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TareaScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.newspaper), // Ícono para la nueva opción
            title: const Text('Noticias'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const NoticiaScreen(),
                ), // Navega a MiAppScreen
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.apps), // Ícono para la nueva opción
            title: const Text('Mi App'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MiAppScreen(),
                ), // Navega a MiAppScreen
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
            leading: const Icon(Icons.stars), // Ícono para el contador
            title: const Text('Juego'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const StartScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info), // Ícono para el contador
            title: const Text('Acerca de'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AcercaScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              DialogHelper.mostrarDialogoCerrarSesion(context);
            },
          ),
        ],
      ),
          ),
        ],
      ),
    );
  }
}
