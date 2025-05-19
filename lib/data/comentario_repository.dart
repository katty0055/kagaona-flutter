import 'package:kgaona/api/service/comentario_service.dart';
import 'package:kgaona/domain/comentario.dart';
import 'package:kgaona/exceptions/api_exception.dart';

class ComentarioRepository {
  final ComentarioService _comentarioService = ComentarioService();

  /// Método privado para validar un comentario
  void _validarComentario(Comentario comentario) {
    if (comentario.texto.isEmpty) {
      throw Exception('El texto del comentario no puede estar vacío.');
    }
    if (comentario.autor.isEmpty) {
      throw Exception('El autor del comentario no puede estar vacío.');
    }
    if (comentario.noticiaId.isEmpty) {
      throw Exception('El ID de la noticia no puede estar vacío.');
    }
  }

  /// Método privado para validar un subcomentario
  void _validarSubcomentario(Comentario subcomentario) {
    _validarComentario(subcomentario);
    if (subcomentario.idSubComentario == null || subcomentario.idSubComentario!.isEmpty) {
      throw Exception('El ID del comentario padre no puede estar vacío.');
    }
    if (!subcomentario.isSubComentario) {
      throw Exception('El comentario debe marcarse como subcomentario.');
    }
  }

  /// Obtiene todos los comentarios de una noticia específica
  Future<List<Comentario>> obtenerComentariosPorNoticia(String noticiaId) async {
    try {
      if (noticiaId.isEmpty) {
        throw Exception('El ID de la noticia no puede estar vacío.');
      }
      return await _comentarioService.obtenerComentariosPorNoticia(noticiaId);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      } else {
        throw Exception('Error al obtener comentarios: $e');
      }
    }
  }

  /// Agrega un nuevo comentario a una noticia
  Future<void> agregarComentario(Comentario comentario) async {
    try {
      _validarComentario(comentario);
      await _comentarioService.agregarComentario(comentario);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      } else {
        throw Exception('Error al agregar comentario: $e');
      }
    }
  }

  /// Obtiene el número de comentarios para una noticia específica
  Future<int> obtenerNumeroComentarios(String noticiaId) async {
    try {
      if (noticiaId.isEmpty) {
        throw Exception('El ID de la noticia no puede estar vacío.');
      }
      return await _comentarioService.obtenerNumeroComentarios(noticiaId);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      } else {
        throw Exception('Error al obtener número de comentarios: $e');
      }
    }
  }

  /// Registra una reacción (like o dislike) a un comentario
  Future<void> reaccionarComentario(
    String comentarioId, 
    String tipo, 
    bool incrementar, String? comentarioPadreId
  ) async {
    try {
      if (comentarioId.isEmpty) {
        throw Exception('El ID del comentario no puede estar vacío.');
      }
      
      // Validar el tipo de reacción
      if (tipo != 'like' && tipo != 'dislike') {
        throw Exception('El tipo de reacción debe ser "like" o "dislike".');
      }
      
      await _comentarioService.reaccionarComentario(
        comentarioId, 
        tipo, 
        incrementar
      );
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      } else {
        throw Exception('Error al registrar reacción: $e');
      }
    }
  }

  /// Agrega un subcomentario a un comentario existente
  /// Los subcomentarios no pueden tener a su vez subcomentarios
  Future<void> agregarSubcomentario(Comentario subcomentario) async {
    try {
      _validarSubcomentario(subcomentario);
      await _comentarioService.agregarSubcomentario(subcomentario);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      } else {
        throw Exception('Error al agregar subcomentario: $e');
      }
    }
  }
}
