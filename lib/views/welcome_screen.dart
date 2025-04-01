import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  _mostrarCotizaciones() {
    print("Cotizacion");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bienvenido')),
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
