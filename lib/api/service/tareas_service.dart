import 'dart:async';
import '../../data/task_repository.dart';
import '../../domain/task.dart';

class TareasService {
  final TaskRepository _taskRepository = TaskRepository();

  Future<List<Task>> obtenerTareas({int inicio = 0, int limite = 10}) async {
    // Simula un retraso para imitar una llamada a una API
    await Future.delayed(const Duration(milliseconds: 500));

    // Obtiene las tareas del repositorio
    return _taskRepository.getTasks().skip(inicio).take(limite).toList();
  }

  Future<void> agregarTarea(Task tarea) async {
    // Simula un retraso para imitar una llamada a una API
    await Future.delayed(const Duration(milliseconds: 500));

    // Obtiene la lista actual de tareas
    final tareas = _taskRepository.getTasks();

    // Alterna entre 'normal' y 'urgente' basado en la cantidad actual de tareas
    final tipo = tareas.length % 2 == 0 ? 'normal' : 'urgente';

    // Crea una nueva tarea con el tipo alternado
    final nuevaTarea = Task(
      title: tarea.title,
      type: tipo, // Asigna el tipo alternado
      description: tarea.description,
      date: tarea.date,
    );

    // Agrega la nueva tarea al repositorio
    _taskRepository.addTask(nuevaTarea);
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