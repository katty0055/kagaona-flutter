import 'package:kgaona/api/service/base_service.dart';
import 'package:kgaona/constants/constantes.dart';
import 'package:kgaona/core/api_config.dart';
import 'package:kgaona/domain/noticia.dart';

class NoticiaService extends BaseService {
  /// Obtiene todas las noticias desde la API
  Future<List<Noticia>> obtenerNoticias() async {
    final List<dynamic> noticiasJson = await get<List<dynamic>>(
      ApiConfig.noticiasEndpoint,
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
      ApiConfig.noticiasEndpoint,
      data: noticia.toMap(),
      errorMessage: 'Error al crear la noticia',
    );
  }

  /// Edita una noticia existente en la API
  Future<void> editarNoticia(Noticia noticia) async {
    final url = '${ApiConfig.noticiasEndpoint}/${noticia.id}';
    await put(
      url,
      data: noticia.toMap(),
      errorMessage: 'Error al editar la noticia',
    );
  }

  /// Elimina una noticia existente en la API
  Future<void> eliminarNoticia(String id) async {
    final url = '${ApiConfig.noticiasEndpoint}/$id';
    await delete(url, errorMessage: 'Error al eliminar la noticia');
  }
}
