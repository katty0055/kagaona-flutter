import 'dart:async';

class TareasService {
  final List<Map<String, dynamic>> _tareas = [];

  Future<List<Map<String, dynamic>>> obtenerTareas({int inicio = 0, int limite = 10}) async {
    // Simula un retraso para imitar una llamada a una API
    await Future.delayed(const Duration(seconds: 1));

    // Devuelve un subconjunto de tareas
    return _tareas.skip(inicio).take(limite).toList();
  }

  Future<void> agregarTarea(Map<String, dynamic> tarea) async {
    // Simula un retraso para imitar una llamada a una API
    await Future.delayed(const Duration(milliseconds: 500));
    _tareas.add(tarea);
  }

  Future<void> eliminarTarea(int index) async {
    // Simula un retraso para imitar una llamada a una API
    await Future.delayed(const Duration(milliseconds: 500));
    _tareas.removeAt(index);
  }
}