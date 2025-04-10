import 'package:flutter/material.dart';
import 'package:kgaona/helpers/task_card_helper.dart';
import 'package:kgaona/domain/task.dart';
import 'package:kgaona/constants.dart';

class TaskDetailsScreen extends StatelessWidget {
  final List<Task> tareas;
  final int indice;

  const TaskDetailsScreen({super.key, required this.tareas, required this.indice});

  @override
  Widget build(BuildContext context) {
    final Task tarea = tareas[indice];
    final String imageUrl = 'https://picsum.photos/200/300?random=$indice';
    final String fechaLimiteDato = tarea.fechaLimite != null
        ? '${tarea.fechaLimite!.day}/${tarea.fechaLimite!.month}/${tarea.fechaLimite!.year}'
        : 'Sin fecha límite';

    return Scaffold(
      backgroundColor: Colors.white,
      body: 
          GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null) {
                if (details.primaryVelocity! > 0) {
                  // Deslizar hacia la derecha
                  if (indice > 0) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailsScreen(
                          tareas: tareas,
                          indice: indice - 1,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No hay tareas antes de esta tarea')),
                    );
                  }
                } else if (details.primaryVelocity! < 0) {
                  // Deslizar hacia la izquierda
                  if (indice < tareas.length - 1) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailsScreen(
                          tareas: tareas,
                          indice: indice + 1,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: CommonWidgetsHelper.buildNoStepsText(),
                      ),
                    );
                  }
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Center(
                child: Card(
                  elevation: 8, // Borde sombreado
                  color: Colors.white, // Color de fondo blanco
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: CommonWidgetsHelper.buildRoundedBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0), // Agrega un padding de 10 alrededor del Card
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Imagen aleatoria
                        ClipRRect(
                          borderRadius: CommonWidgetsHelper.buildTopRoundedBorder(),
                          child: Image.network(
                            imageUrl,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        CommonWidgetsHelper.buildSpacing(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Título
                            CommonWidgetsHelper.buildBoldTitle(tarea.title),
                            CommonWidgetsHelper.buildSpacing(), // Espacio entre el título y la descripción
                            // Pasos (máximo 3 líneas)
                            if (tarea.pasos != null && tarea.pasos!.isNotEmpty)
                              CommonWidgetsHelper.buildInfoLines(
                                tarea.pasos![0],
                                tarea.pasos!.length > 1 ? tarea.pasos![1] : null,
                                tarea.pasos!.length > 2 ? tarea.pasos![2] : null,
                              )
                            else
                              CommonWidgetsHelper.buildNoStepsText(),
                            CommonWidgetsHelper.buildSpacing(),                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alinea el botón a la derecha
                              children: [
                                CommonWidgetsHelper.buildBoldFooter('$fechaLimite $fechaLimiteDato'),
                                ElevatedButton.icon(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(Icons.arrow_back, size: 16),
                                  label: const Text('Volver'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
  }
}