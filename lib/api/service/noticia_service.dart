import 'package:kgaona/api/service/base_service.dart';
import 'package:kgaona/constants/constantes.dart';
import 'package:kgaona/domain/noticia.dart';

class NoticiaService extends BaseService {
  /// Obtiene todas las noticias desde la API
  Future<List<Noticia>> obtenerNoticias() async {
    final List<dynamic> noticiasJson = await get<List<dynamic>>(
      ApiConstantes.noticiasEndpoint,
      errorMessage: NoticiasConstantes.mensajeError,
    );

    return noticiasJson
        .map<Noticia>(
          (json) => NoticiaMapper.fromMap(json as Map<String, dynamic>),
        )
        .toList();
  }

  /// Crea una nueva noticia en la API
  Future<void> crearNoticia(Noticia noticia) async {
    await post(
      ApiConstantes.noticiasEndpoint,
      data: noticia.toMap(),
      errorMessage: NoticiasConstantes.errorCreated,
    );
  }

  /// Edita una noticia existente en la API
  Future<void> editarNoticia(Noticia noticia) async {
    final url = '${ApiConstantes.noticiasEndpoint}/${noticia.id}';
    await put(
      url,
      data: noticia.toMap(),
      errorMessage: NoticiasConstantes.errorUpdated,
    );
  }

  /// Elimina una noticia existente en la API
  Future<void> eliminarNoticia(String id) async {
    final url = '${ApiConstantes.noticiasEndpoint}/$id';
    await delete(url, errorMessage: NoticiasConstantes.errorDelete);
  }
}
