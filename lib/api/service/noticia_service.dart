import 'package:kgaona/constants.dart';
import 'package:kgaona/data/noticia_repository.dart';
import 'package:kgaona/domain/noticia.dart';

class NoticiaService {
  final NoticiaRepository _noticiaRepository = NoticiaRepository();

  // Método privado para validar una noticia
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

  Future<List<Noticia>> obtenerNoticias({
    required int numeroPagina,
    int tamanoPagina = Constants.pageSize,
    bool cargaInicial = false,
  }) async {
    try {
      final todasLasNoticias = await _noticiaRepository.fetchNoticiasDIO();

      // Implementar paginación en el cliente
      final inicio = (numeroPagina - 1) * tamanoPagina;
      final fin = inicio + tamanoPagina;

      return todasLasNoticias.sublist(
        inicio,
        fin > todasLasNoticias.length ? todasLasNoticias.length : fin,
      );
    } catch (e) {
      final error = e.toString();
      if (error.contains('Error HTTP 400')) {
        throw Exception('Solicitud inválida. agotaste la api.');
      } else if (error.contains('Error HTTP 404')) {
        throw Exception('No se encontraron noticias.');
      } else if (error.contains('Error HTTP 500')) {
        throw Exception('Problema en el servidor. Intenta más tarde.');
      } else if (error.contains('Error de conexión')) {
        throw Exception('No se pudo conectar con el servidor. Verifica tu conexión a Internet.');
      } else {
        throw Exception('Error desconocido: $error');
      }
    }
  }

  Future<String> crearNoticia(Noticia noticia) async {
    try {
      // Validar la noticia antes de enviarla
      _validarNoticia(noticia);

      // Llamar al repositorio para crear la noticia
      await _noticiaRepository.crearNoticia(noticia);

      // Devolver un mensaje de éxito
      return 'Noticia creada exitosamente';

    } catch (e) {
      // Interpretar el error y devolver un mensaje adecuado
      final error = e.toString();
      if (error.contains('Error HTTP 400')) {
        throw Exception('Datos inválidos. Verifica la información.');
      } else if (error.contains('Error HTTP 500')) {
        throw Exception('Problema en el servidor. Intenta más tarde.');
      } else if (error.contains('Error de conexión')) {
        throw Exception('No se pudo conectar con el servidor. Verifica tu conexión a Internet.');
      } else {
        throw Exception('Error desconocido: $error');
      }
    }
  }

  Future<String> editarNoticia(String id, Noticia noticia) async {
    try {
      await _noticiaRepository.editarNoticia(id, noticia);
      return 'Noticia editada exitosamente';
    } catch (e) {
      final error = e.toString();
      if (error.contains('Error HTTP 400')) {
        throw Exception('Datos inválidos. Verifica la información.');
      } else if (error.contains('Error HTTP 500')) {
        throw Exception('Problema en el servidor. Intenta más tarde.');
      } else if (error.contains('Error de conexión')) {
        throw Exception('No se pudo conectar con el servidor. Verifica tu conexión a Internet.');
      } else {
        throw Exception('Error desconocido: $error');
      }
    }
  }

  Future<String> eliminarNoticia(String id) async {
    try {
      if (id.isEmpty) {
        throw Exception('El ID de la noticia no puede estar vacío.');
      }
      
      await _noticiaRepository.eliminarNoticia(id);
      return 'Noticia eliminada exitosamente';
    } catch (e) {
      final error = e.toString();
      if (error.contains('Error HTTP 400')) {
        throw Exception('Solicitud inválida. No se pudo eliminar, recargue la pagina.');
      } else if (error.contains('Error HTTP 404')) {
        throw Exception('No se encontró la noticia a eliminar.');
      } else if (error.contains('Error HTTP 500')) {
        throw Exception('Problema en el servidor. Intenta más tarde.');
      } else if (error.contains('Error de conexión')) {
        throw Exception('No se pudo conectar con el servidor. Verifica tu conexión a Internet.');
      } else {
        throw Exception('Error desconocido: $error');
      }
    }
  }
}