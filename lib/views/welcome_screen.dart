import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido'),
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
                  const SnackBar(
                    content: Text('Listando cotizaciones...'),
                  ),
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