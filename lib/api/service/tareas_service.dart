import 'dart:async';
import '../../data/task_repository.dart';
import '../../domain/task.dart';

class TareasService {
  final TaskRepository _taskRepository = TaskRepository();

  Future<List<Task>> obtenerTareas({int inicio = 0, int limite = 10}) async {
    // Simula un retraso para imitar una llamada a una API
    await Future.delayed(const Duration(seconds: 1));

    // Obtiene las tareas del repositorio y devuelve un subconjunto
    final tareas = _taskRepository.getTasks();
    return tareas.skip(inicio).take(limite).toList();
  }

  Future<void> agregarTarea(Task tarea) async {
    // Simula un retraso para imitar una llamada a una API
    await Future.delayed(const Duration(milliseconds: 500));
    _taskRepository.addTask(tarea);
  }

  Future<void> eliminarTarea(int index) async {
    // Simula un retraso para imitar una llamada a una API
    await Future.delayed(const Duration(milliseconds: 500));
    _taskRepository.removeTask(index);
  }

  Future<void> actualizarTarea(int index, Task tareaActualizada) async {
    // Simula un retraso para imitar una llamada a una API
    await Future.delayed(const Duration(milliseconds: 500));
    final tareas = _taskRepository.getTasks();
    if (index >= 0 && index < tareas.length) {
      tareas[index] = tareaActualizada;
    }
  }
}