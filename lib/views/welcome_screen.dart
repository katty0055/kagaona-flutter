import 'package:flutter/material.dart';
import 'package:kgaona/views/tareasscreen.dart';
import 'package:kgaona/views/login_screen.dart';
import 'package:kgaona/views/base_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bienvenido')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.pinkAccent),
              child: Text(
                'Menú de Navegación',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.task),
              title: Text('Inicio'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.task),
              title: Text('Tareas'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TareasScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Salir'),
              onTap: () {
                // Cierra la aplicación
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Confirmar'),
                      content: Text('¿Estás seguro de que deseas salir?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Cierra el diálogo
                          },
                          child: Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Cierra el diálogo
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            ); // Redirige al login
                          },
                          child: Text('Salir'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),

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
              ...quotes.map((quote) => Text(quote)).toList(),
            ElevatedButton(
              onPressed: _mostrarCotizaciones,
              child: Text("Cotizaciones"),
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
    );
  }
}
