import '../domain/task.dart';

class TaskRepository {
  final List<Task> _tasks = [
    Task(title: 'Tarea 1', type: 'normal', description: 'Descripción de la tarea 1', date: DateTime(2025, 4, 7)),
    Task(title: 'Tarea 2', type: 'urgente', description: 'Descripción de la tarea 2', date: DateTime(2025, 4, 8)),
    Task(title: 'Tarea 3', type: 'normal', description: 'Descripción de la tarea 3', date: DateTime(2025, 4, 9)),
    Task(title: 'Tarea 4', type: 'urgente', description: 'Descripción de la tarea 4', date: DateTime(2025, 4, 10)),
    Task(title: 'Tarea 5', type: 'normal', description: 'Descripción de la tarea 5', date: DateTime(2025, 4, 11)),
  ];

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

  void addTask(Task task) {
    // Alterna entre 'normal' y 'urgente' basado en la cantidad actual de tareas
    final tipo = _tasks.length % 2 == 0 ? 'normal' : 'urgente';

    // Crea una nueva tarea con el tipo alternado
    final nuevaTarea = Task(
      title: task.title,
      type: tipo,
      description: task.description,
      date: task.date,
    );

    _tasks.add(nuevaTarea);
  }

  void removeTask(int index) {
    _tasks.removeAt(index);
    print('Tarea eliminada: ${index}');
  }
}