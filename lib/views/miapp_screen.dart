/*
 ¿Por qué usamos setState aquí? ¿Qué pasa si no lo usamos?
 Usamos el setState para avisar cuando se debe reconstruir el widget.
 Si no lo usamos no cambiara el valor del contador en la pantalla.
*/ 

import 'package:flutter/material.dart';

class MiAppScreen extends StatefulWidget {
  const MiAppScreen({super.key});

  @override
  _MiAppScreenState createState() => _MiAppScreenState();
}

class _MiAppScreenState extends State<MiAppScreen> {
  int _contador = 0; // Variable para el contador

  void _incrementarContador() {
    setState(() {
      _contador++; // Incrementa el contador
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.green, // Cambia el color del fondo
              padding: const EdgeInsets.all(20),
              child: const Text(
                'Hola, Flutter',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Veces presionado: $_contador', // Muestra el valor del contador
              style: const TextStyle(fontSize: 20, color: Colors.blue),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _incrementarContador, // Incrementa el contador al presionar
              child: const Text('Toca aqui'),
            ),
          ],
        ),
      ),
    );
  }
}