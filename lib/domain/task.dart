class Task {
  final String title;
  final String type;
  final String? description;
  final DateTime? date;

  Task({
    required this.title,
    this.type = 'normal', // Valor por defecto
    this.description,
    this.date,
  });
}