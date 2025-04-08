import 'package:kgaona/api/service/servicio_tareas.dart';

import '../domain/task.dart';

class TaskRepository {
  final List<Task> _tasks = [
    Task(title: 'Tarea 1', type: 'normal', description: 'Descripción de la tarea 1',
     date: DateTime(2025, 4, 7),fechaLimite:DateTime.now().add(Duration(days: 1))),
    Task(title: 'Tarea 2', type: 'urgente', description: 'Descripción de la tarea 2',
     date: DateTime(2025, 4, 8), fechaLimite:DateTime.now().add(Duration(days: 2))),
    Task(title: 'Tarea 3', type: 'normal', description: 'Descripción de la tarea 3',
     date: DateTime(2025, 4, 9), fechaLimite:DateTime.now().add(Duration(days: 3))),
    Task(title: 'Tarea 4', type: 'urgente', description: 'Descripción de la tarea 4',
     date: DateTime(2025, 4, 10), fechaLimite:DateTime.now().add(Duration(days: 4))),
    Task(title: 'Tarea 5', type: 'normal', description: 'Descripción de la tarea 5', 
    date: DateTime(2025, 4, 11), fechaLimite:DateTime.now().add(Duration(days: 5))),
  ];
  final ServicioTareas _servicioTareas = ServicioTareas();

  List<Task> getTasks() {
    // Genera tareas adicionales si no hay suficientes
    while (_tasks.length < 100) {
      final tipo = _tasks.length % 2 == 0 ? 'normal' : 'urgente';
      _tasks.add(Task(
        title: 'Tarea ${_tasks.length + 1}',
        type: tipo,
        description: 'Descripción de la tarea ${_tasks.length + 1}',
        date: DateTime.now(),
      ));
    }
    return _tasks;
  }

  Future<void> addTask(Task task) async {
    // Alterna entre 'normal' y 'urgente' basado en la cantidad actual de tareas
    final tipo = _tasks.length % 2 == 0 ? 'normal' : 'urgente';

    // Genera una fecha límite para la tarea (3 días después de la fecha actual)
    final fechaLimite = DateTime.now().add(const Duration(days: 3));

    // Obtiene los pasos desde el servicio
    final pasos = await _servicioTareas.obtenerPasos(task.title);

    // Crea una nueva tarea con el tipo alternado
    final nuevaTarea = Task(
      title: task.title,
      type: tipo,
      description: task.description,
      date: task.date,
      fechaLimite: fechaLimite,
      pasos: pasos,
    );

    _tasks.add(nuevaTarea);
  }

  void removeTask(int index) {
    _tasks.removeAt(index);
    print('Tarea eliminada: ${index}');
  }
}