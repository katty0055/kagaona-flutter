import 'dart:async';
import '../../data/task_repository.dart';
import '../../domain/task.dart';

class TareasService {
  final TaskRepository _taskRepository = TaskRepository();

  Future<List<Task>> obtenerTareas({int inicio = 0, int limite = 10}) async {
    // Simula un retraso para imitar una llamada a una API
    await Future.delayed(const Duration(milliseconds: 500));

    // Obtiene las tareas del repositorio
    final tareas = _taskRepository.getTasks().skip(inicio).take(limite).toList();

    final tareasConPasos = await Future.wait(tareas.map((tarea) async {
    if (tarea.pasos == null || tarea.pasos!.isEmpty) {
      final pasos = await obtenerPasos(tarea.title, tarea.fechaLimite);
      return Task(
        title: tarea.title,
        type: tarea.type,
        description: tarea.description,
        date: tarea.date,
        fechaLimite: tarea.fechaLimite,
        pasos: pasos,
      );
    }
      return tarea;
    }));

    return tareasConPasos;
  }

  Future<void> agregarTarea(Task tarea) async {
    // Simula un retraso para imitar una llamada a una API
    await Future.delayed(const Duration(milliseconds: 500));

    // Genera pasos para la tarea
    final pasos = await obtenerPasos(tarea.title, tarea.fechaLimite);

    // Crea una nueva tarea con los pasos generados
    final nuevaTarea = Task(
      title: tarea.title,
      type: tarea.type,
      description: tarea.description,
      date: tarea.date,
      fechaLimite: tarea.fechaLimite ?? DateTime.now().add(const Duration(days: 3)),
      pasos: pasos,
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

    // Genera pasos actualizados para la tarea
    final pasos = await obtenerPasos(tareaActualizada.title, tareaActualizada.fechaLimite);

    // Crea una tarea actualizada con los pasos generados
    final tareaConPasos = Task(
      title: tareaActualizada.title,
      type: tareaActualizada.type,
      description: tareaActualizada.description,
      date: tareaActualizada.date,
      fechaLimite: tareaActualizada.fechaLimite,
      pasos: pasos,
    );

    // Actualiza la tarea en el repositorio
    _taskRepository.updateTask(index, tareaConPasos);
  }

  Future<List<String>> obtenerPasos(String tituloTarea, DateTime? fechaLimite) async {
    // Simula un retraso para imitar una consulta a un asistente de IA
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Convierte la fecha límite a una cadena que solo muestra la fecha
    final String fechaFormateada = fechaLimite != null
      ? fechaLimite.toIso8601String().split('T')[0] // Obtiene solo la parte de la fecha
      : 'sin fecha límite';

    // Genera pasos personalizados basados en el título de la tarea y la fecha límite
    return [
      'Paso 1: Planificar antes del $fechaFormateada',
      'Paso 2: Ejecutar antes del $fechaFormateada',
      'Paso 3: Revisar antes del $fechaFormateada',
    ];
  }
}