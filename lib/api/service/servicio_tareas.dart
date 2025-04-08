import 'dart:async';

class ServicioTareas {
  Future<List<String>> obtenerPasos(String tituloTarea) async {
    // Simula un retraso para imitar una consulta a un asistente de IA
    await Future.delayed(const Duration(milliseconds: 500));

    // Genera pasos basados en el título de la tarea
    return [
      'Paso 1: Planificar $tituloTarea',
      'Paso 2: Ejecutar $tituloTarea',
      'Paso 3: Revisar $tituloTarea',
    ];
  }
}