import 'package:flutter/material.dart';
import 'package:kgaona/constants.dart';
import '../domain/task.dart';
import '../helpers/task_card_helper.dart'; // Importa construirTarjetaDeportiva

class TaskDetailsScreen extends StatelessWidget {
  final Task tarea;
  final int indice;

  const TaskDetailsScreen({Key? key, required this.tarea, required this.indice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String imageUrl = 'https://picsum.photos/200/300?random=$indice';
    final String fechaLimite = tarea.fechaLimite != null
      ? '${tarea.fechaLimite!.day}/${tarea.fechaLimite!.month}/${tarea.fechaLimite!.year}'
      : 'Sin fecha límite';

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(tarea.title),
      // ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical:138.0, horizontal: 8.0), // Espacio arriba y abajo
        child: Card(
          elevation: 3, // Borde sombreado
          color: Colors.white, // Color de fondo blanco
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Borde redondeado
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0), // Agrega un padding de 10 alrededor del Card
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Imagen aleatoria
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  child: Image.network(
                    imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    Text(
                      tarea.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Pasos (máximo 3 líneas)
                    if (tarea.pasos != null && tarea.pasos!.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: tarea.pasos!
                            .take(3) // Toma un máximo de 3 pasos
                            .map((paso) => Text(
                                  paso,
                                  style: const TextStyle(fontSize: 18, color: Colors.black, fontFamily: 'Roboto',),
                                ))
                            .toList(),
                      )
                    else
                      const Text(
                        'No hay pasos disponibles',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    const SizedBox(height: 7),
                    // Fecha límite
                    Text(
                      '$FECHA_LIMITE $fechaLimite',
                      style: const TextStyle(
                        fontSize: 18, 
                        // color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),            
          ),
        ),
      ),
    );
  }
}