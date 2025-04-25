import 'package:kgaona/constants.dart';

class Noticia {
  final String? id; // Campo opcional para manejar creación y edición
  final String titulo;
  final String descripcion;
  final String fuente;
  final DateTime publicadaEl;
  final String imagenUrl; // Campo para la URL de la imagen
  final String categoriaId; // Nuevo campo para el ID de la categoría

  Noticia({
    this.id, // El id es opcional
    required this.titulo,
    required this.descripcion,
    required this.fuente,
    required this.publicadaEl,
    required this.imagenUrl,
    required this.categoriaId, // Campo requerido para la categoría
  });

  // Método para convertir un JSON en una instancia de Noticia
  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      id: json['_id'], // El id viene del servidor
      titulo: json['titulo'] ?? 'Sin título',
      descripcion: json['descripcion'] ?? 'Sin descripción',
      fuente: json['fuente'] ?? 'Fuente desconocida',
      publicadaEl: DateTime.tryParse(json['publicadaEl'] ?? '') ?? DateTime.now(),
      imagenUrl: json['imagenUrl'] ?? 'https://via.placeholder.com/150',
      categoriaId: json['categoriaId'] ?? ConstantesCategoria.defaultcategoriaId, // Valor por defecto si no hay categoría
    );
  }

  // Método para convertir una instancia de Noticia a JSON
  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'fuente': fuente,
      'publicadaEl': publicadaEl.toIso8601String(),
      'imagenUrl': imagenUrl,
      'categoriaId': categoriaId,
    };
  }
}