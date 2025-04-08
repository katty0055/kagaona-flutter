import 'package:flutter/material.dart';
import '../domain/task.dart';
import '../helpers/task_card_helper.dart'; // Importa construirTarjetaDeportiva

class TaskDetailsScreen extends StatelessWidget {
  final Task tarea;
  final int indice;

  const TaskDetailsScreen({Key? key, required this.tarea, required this.indice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tarea.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: construirTarjetaDeportiva(tarea, indice), // Usa construirTarjetaDeportiva
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Cierra la pantalla y regresa a la anterior
              },
              child: const Text('Cerrar'),
            ),
          ),
        ],
      ),
    );
  }
}