/*
¿Qué hace el Container en este código? ¿Cómo organiza Column los elementos?"
El container esta dentro de la Columna, agrega estilo al texto, color verde al fondo,
un texto de 24px y un padding de 20px. La columna organiza los elementos en una sola 
columna, es decir los elementos aparecen en filas, uno debajo del otro.
*/ 

import 'package:flutter/material.dart';

class MiAppScreen extends StatelessWidget {
  const MiAppScreen({super.key});

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
              //cambia el color del fondo
              color:Colors.green,
              padding: const EdgeInsets.all(20),
              child: const Text(
                'Hola, Flutter',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Acción al presionar el botón
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Botón presionado')),
                );
              },
              child: const Text('Toca aqui'),
            ),
          ],
        ),
      ),
    );
  }
}