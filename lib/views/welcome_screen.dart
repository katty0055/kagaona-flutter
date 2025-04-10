import 'package:flutter/material.dart';
import 'package:kgaona/components/side_menu.dart';
//import 'package:kgaona/views/tareasscreen.dart';
import 'package:kgaona/views/login_screen.dart';
import 'package:kgaona/views/tareas_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  List<String> quotes = [];
  bool isLoading = false;

  Future<void> fetchQuotes() async {
    setState(() {
      isLoading = true;
    });

    // Simulación de una llamada a una API o base de datos
    await Future.delayed(const Duration(seconds: 2)); // Simula un retraso
    setState(() {
      quotes = [
        'Cotización 1: 100',
        'Cotización 2: 200',
        'Cotización 3: 300',
        'Cotización 4: 400',
      ];
      isLoading = false;
    });
  }

  void _mostrarCotizaciones() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cotizaciones'),
          content: SingleChildScrollView(
            child: Column(
              children:
                  quotes.map((quote) => ListTile(title: Text(quote))).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  int _selectedIndex = 0;

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
    return Scaffold(
      appBar: AppBar(title: const Text('Bienvenido')),
      drawer: const SideMenu(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¡Bienvenido!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Has iniciado sesión exitosamente.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Acción para listar cotizaciones
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Listando cotizaciones...')),
                );
              },
              child: const Text('Listar Cotizaciones PS'),
            ),
            ElevatedButton(
              onPressed: fetchQuotes,
              child: const Text('Listar Cotizaciones'),
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const CircularProgressIndicator()
            else
              ...quotes.map((quote) => Text(quote)),
            ElevatedButton(
              onPressed: _mostrarCotizaciones,
              child: const Text("Cotizaciones"),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes agregar la lógica para listar cotizaciones
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Listando cotizaciones...')),
                );
              },
              child: const Text('Listar Cotizaciones'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Índice del elemento seleccionado
        onTap: _onItemTapped, // Maneja el evento de selección
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Añadir Tarea'),
          BottomNavigationBarItem(icon: Icon(Icons.close), label: "Salir"),
        ],
      ),
    );
  }
}
