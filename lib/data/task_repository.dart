import '../domain/task.dart';

class TaskRepository {
  final List<Task> _tasks = [
    Task(
      title: 'Tarea 1',
      type: 'normal',
      description: 'Descripción de la tarea 1',
      date: DateTime(2025, 4, 14),
      fechaLimite: DateTime.now().add(const Duration(days: 1)),
      pasos: [
      'Paso 1: Planificar antes del 15/04/2025', 
      'Paso 2: Ejecutar antes del 15/04/2025',
      'Paso 3: Revisar antes del 15/04/2025',
      ],
    ),
    Task(
      title: 'Tarea 2',
      type: 'urgente',
      description: 'Descripción de la tarea 2',
      date: DateTime(2025, 4, 13),
      fechaLimite: DateTime.now().add(const Duration(days: 2)),
      pasos: [
      'Paso 1: Planificar antes del 15/04/2025', 
      'Paso 2: Ejecutar antes del 15/04/2025',
      'Paso 3: Revisar antes del 15/04/2025',
      ],
    ),
    Task(
      title: 'Tarea 3',
      type: 'normal',
      description: 'Descripción de la tarea 3',
      date: DateTime(2025, 4, 12),
      fechaLimite: DateTime.now().add(const Duration(days: 3)),
      pasos: [
      'Paso 1: Planificar antes del 15/04/2025', 
      'Paso 2: Ejecutar antes del 15/04/2025',
      'Paso 3: Revisar antes del 15/04/2025',
      ],
    ),
    Task(
      title: 'Tarea 4',
      type: 'uregente',
      description: 'Descripción de la tarea 4',
      date: DateTime(2025, 4, 11),
      fechaLimite: DateTime.now().add(const Duration(days: 3)),
      pasos: [
      'Paso 1: Planificar antes del 15/04/2025', 
      'Paso 2: Ejecutar antes del 15/04/2025',
      'Paso 3: Revisar antes del 15/04/2025',
      ],
    ),
    Task(
      title: 'Tarea 5',
      type: 'normal',
      description: 'Descripción de la tarea 5',
      date: DateTime(2025, 4, 10),
      fechaLimite: DateTime.now().add(const Duration(days: 3)),
      pasos: [
      'Paso 1: Planificar antes del 15/04/2025', 
      'Paso 2: Ejecutar antes del 15/04/2025',
      'Paso 3: Revisar antes del 15/04/2025',
      ],
    ),
  ];

  List<Task> getTasks() {
    while (_tasks.length < 100) {
      final tipo = _tasks.length % 2 == 0 ? 'normal' : 'urgente';
      _tasks.add(Task(
        title: 'Tarea ${_tasks.length + 1}',
        type: tipo,
        description: 'Descripción de la tarea ${_tasks.length + 1}',
        date: DateTime.now(),
        fechaLimite: DateTime.now().add(Duration(days: _tasks.length % 5 + 1)),
      ));
    }
    return _tasks;
  }

  void addTask(Task task) {
    _tasks.add(task);
  }

  void removeTask(int index) {
    _tasks.removeAt(index);
  }

  void updateTask(int index, Task updatedTask) {
    if (index >= 0 && index < _tasks.length) {
      _tasks[index] = updatedTask;
    }
  }
}