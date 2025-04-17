import 'package:kgaona/constants.dart';
import 'package:kgaona/data/noticia_repository.dart';
import 'package:kgaona/domain/noticia.dart';

class NoticiaService {
  final NoticiaRepository _noticiaRepository = NoticiaRepository();

  // Método para obtener las noticias iniciales del repositorio
  Future<List<Noticia>> obtenerNoticiasIniciales() async {
    final noticias = await _noticiaRepository.fetchNoticias();

    // Validar las noticias obtenidas
    for (final noticia in noticias) {
      _validarNoticia(noticia);
    }

    return noticias;
  }

  // Método para obtener noticias paginadas (scroll infinito)
  Future<List<Noticia>> obtenerNoticiasPaginadas({
    required int numeroPagina,
    int tamanoPagina = Constants.pageSize, // Tamaño de página predeterminado
  }) async {
    // Validaciones de paginación
    if (numeroPagina < 1) {
      throw Exception('El número de página debe ser mayor o igual a 1.');
    }
    if (tamanoPagina <= 0) {
      throw Exception('El tamaño de página debe ser mayor que 0.');
    }

    final noticias = await _noticiaRepository.fetchMoreNoticias(numeroPagina, tamanoPagina);

    // Validar las noticias obtenidas
    for (final noticia in noticias) {
      _validarNoticia(noticia);
    }

    return noticias;
  }

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
}