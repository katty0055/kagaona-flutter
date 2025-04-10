import 'dart:async';
import 'package:kgaona/data/assistant_repository.dart';
import '../../data/task_repository.dart';
import '../../domain/task.dart';

class TareasService {
  final TaskRepository _taskRepository = TaskRepository();
  final AssistantRepository _assistantRepository = AssistantRepository(); // Instancia del nuevo repositorio

  Future<List<Task>> obtenerTareas({int inicio = 0, int limite = 4}) async {
    // Simula un retraso para imitar una llamada a una API
    await Future.delayed(const Duration(milliseconds: 500));

    // Obtiene las tareas del repositorio
    final tareas = _taskRepository.getTasks().skip(inicio).take(limite).toList();

    final tareasConPasos = await Future.wait(tareas.map((tarea) async {
    if (tarea.pasos == null || tarea.pasos!.isEmpty) {
      final pasos = await generarPasos(tarea.title, tarea.fechaLimite);
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

  Future<Task> agregarTarea(Task tarea) async {
    // Simula un retraso para imitar una llamada a una API
    await Future.delayed(const Duration(milliseconds: 500));

    //las nuevas tareas tengan fechas límite de 1 día desde hoy.
    final fechaNueva = tarea.fechaLimite!.add(const Duration(days: 1));


    // Genera pasos para la tarea
    final pasos = await generarPasos(tarea.title, fechaNueva);

    // Crea una nueva tarea con los pasos generados
    final nuevaTarea = Task(
      title: tarea.title,
      type: tarea.type,
      description: tarea.description,
      date: tarea.date,
      fechaLimite: fechaNueva,
      pasos: pasos,
    );

    // Agrega la nueva tarea al repositorio
    _taskRepository.addTask(nuevaTarea);

    return nuevaTarea;
  }

  Future<void> eliminarTarea(int index) async {
    // Simula un retraso para imitar una llamada a una API
    await Future.delayed(const Duration(milliseconds: 500));
    _taskRepository.removeTask(index);
  }

  Future<Task> actualizarTarea(int index, Task tareaActualizada) async {
    // Simula un retraso para imitar una llamada a una API
    await Future.delayed(const Duration(milliseconds: 500));

    // Genera pasos actualizados para la tarea
    final pasos = await generarPasos(tareaActualizada.title, tareaActualizada.fechaLimite);

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

    return tareaConPasos;
  } 

  Future<List<String>> generarPasos(String titulo, DateTime? fechaLimite) async {
    List<String> pasos = [];

    pasos = await _assistantRepository.generarPasos(titulo, fechaLimite);
     // Retorna solo los dos primeros pasos
    pasos = pasos.sublist(0, pasos.length > 2 ? 2 : pasos.length);
    return pasos;
  }
}