import 'package:kgaona/api/service/noticia_service.dart';
import 'package:kgaona/domain/noticia.dart';
import 'package:kgaona/exceptions/api_exception.dart';

class NoticiaRepository {
  final NoticiaService _noticiaService = NoticiaService();

  /// Método privado para validar una noticia
  void _validarNoticia(Noticia noticia) {
    if (noticia.titulo.isEmpty) {
      throw Exception('El título de la noticia no puede estar vacío.');
    }
    if (noticia.descripcion.isEmpty) {
      throw Exception('La descripción de la noticia no puede estar vacía.');
    }
    if (noticia.fuente.isEmpty) {
      throw Exception('La fuente de la noticia no puede estar vacía.');
    }
    if (noticia.publicadaEl.isAfter(DateTime.now())) {
      throw Exception('La fecha de publicación no puede estar en el futuro.');
    }
  }

  /// Obtiene todas las noticias desde el repositorio
  Future<List<Noticia>> obtenerNoticias() async {
    try {
      return await _noticiaService.obtenerNoticias();
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }

  /// Crea una nueva noticia
  Future<void> crearNoticia(Noticia noticia) async {
    try {
      _validarNoticia(noticia);
      await _noticiaService.crearNoticia(noticia.toJson());
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }

  /// Edita una noticia existente
  Future<void> editarNoticia(String id, Noticia noticia) async {
    try {
      _validarNoticia(noticia);
      await _noticiaService.editarNoticia(id, noticia.toJson());
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }

  ///Elimina una noticia
  Future<void> eliminarNoticia(String id) async {
    try {
      if (id.isEmpty) {
        throw Exception('El ID de la noticia no puede estar vacío.');
      }
      await _noticiaService.eliminarNoticia(id);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      } else {
        throw Exception('Error desconocido: $e');
      }
    }
  }
}
