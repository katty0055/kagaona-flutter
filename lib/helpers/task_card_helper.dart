import 'package:flutter/material.dart';
import '../domain/task.dart';
import '../components/task_card.dart'; // Importa el diseño del Card

Widget buildTaskCard(Task task, VoidCallback onEdit,  {String? subtitulo}) {
  // Lógica para determinar el ícono dinámico
  final Widget leadingIcon = Icon(
    task.type == 'normal' ? Icons.task : Icons.warning,
    color: task.type == 'normal' ? Colors.blue : Colors.red,
    size: 32,
  );

  return TaskCard(
    title: task.title,
    subtitle: subtitulo,
    leadingIcon: leadingIcon, // Pasa el ícono dinámico al Card
    type: task.type,
    description: task.description,
    date: task.date,
    trailing: IconButton(
      icon: const Icon(Icons.edit, color: Colors.blue),
      onPressed: onEdit, // Llama al callback para editar
    ),
  );
}