import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final Widget leadingIcon; // Ícono dinámico pasado desde afuera
  final String type;
  final String? description;
  final DateTime? date;
  final Widget? trailing; // Botón o widget adicional (opcional)

  const TaskCard({
    super.key,
    required this.title,
    required this.leadingIcon,
    required this.type,
    this.description,
    this.date,
    this.trailing, // Acepta un widget adicional
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Borde redondeado
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                leadingIcon, // Ícono dinámico pasado como parámetro
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (trailing != null) trailing!, // Muestra el botón si está definido
              ],
            ),
            const SizedBox(height: 8),
            Text(
              type,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description ?? 'Sin descripción',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              'Fecha: ${date != null ? "${date!.day}/${date!.month}/${date!.year}" : 'Sin fecha'}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}