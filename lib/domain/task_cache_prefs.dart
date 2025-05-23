import 'package:dart_mappable/dart_mappable.dart';
import 'package:kgaona/domain/task.dart';

part 'taskCachePrefs.mapper.dart';

@MappableClass()
class TaskCachePrefs with TaskCachePrefsMappable {
  final String email;
  final List<Task> misTareas;

  const TaskCachePrefs({
    required this.email,
    required this.misTareas,
  });
}
