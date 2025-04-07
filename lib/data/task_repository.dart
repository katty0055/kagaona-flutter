import '../domain/task.dart';

class TaskRepository {
  final List<Task> _tasks = [
    Task(title: 'Tarea 1', type: 'normal'),
    Task(title: 'Tarea 2', type: 'urgente'),
    Task(title: 'Tarea 3', type: 'normal'),
    Task(title: 'Tarea 4', type: 'urgente'),
    Task(title: 'Tarea 5', type: 'normal'),
  ];

  List<Task> getTasks() {
    return _tasks;
  }

  void addTask(Task task) {
    _tasks.add(task);
  }

  void removeTask(int index) {
    _tasks.removeAt(index);
  }
}