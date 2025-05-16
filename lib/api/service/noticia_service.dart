import 'package:dio/dio.dart';
import 'package:kgaona/constants/constantes.dart';
import 'package:kgaona/core/api_config.dart';
import 'package:kgaona/domain/noticia.dart';
import 'package:kgaona/exceptions/api_exception.dart';

class NoticiaService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.beeceptorBaseUrl,
      connectTimeout: const Duration(
        milliseconds: (ConstantesCategoria.timeoutSeconds * 1000),
      ),
      receiveTimeout: const Duration(
        milliseconds: (ConstantesCategoria.timeoutSeconds * 1000),
      ),
            headers: {
        'Authorization': 'Bearer ${ApiConfig.beeceptorApiKey}',
        'Content-Type': 'application/json',
      },
    ),
  );

  /// Obtiene todas las noticias desde la API
  Future<List<Noticia>> obtenerNoticias() async {
    try {
      final response = await _dio.get(ApiConfig.noticiasEndpoint);

      if (response.statusCode == 200) {
        final List<dynamic> noticiasJson = response.data;
        return noticiasJson
            .map<Noticia>(
              (json) => NoticiaMapper.fromMap(json as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw ApiException(
          ConstantesNoticias.mensajeError,
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ApiException(
        'Error al conectar con la API de noticias: $e',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }

  /// Crea una nueva noticia en la API
  Future<void> crearNoticia(Noticia noticia) async {
    try {
      final response = await _dio.post(
        ApiConfig.noticiasEndpoint, 
        data: noticia.toMap()
      );

      if (response.statusCode != 201) {
        throw ApiException(
          'Error al crear la noticia',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException('Error al conectar con la API de noticias: $e');
    }
  }

  /// Edite una noticia existente en la API
  Future<void> editarNoticia(Noticia noticia) async {
    try {      
      final url = '${ApiConfig.noticiasEndpoint}/${noticia.id}';
      final response = await _dio.put(url, data: noticia.toMap());

      if (response.statusCode != 200) {
        throw ApiException(
          'Error al editar la noticia',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException('Error al conectar con la API de noticias: $e');
    }
  }

  /// Elimina una noticia existente en la API
  Future<void> eliminarNoticia(String id) async {
    try {
      final url = '${ApiConfig.noticiasEndpoint}/$id';
      final response = await _dio.delete(url);

      if (response.statusCode != 200 || response.statusCode != 201) {
        throw ApiException(
          'Error al eliminar la noticia',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException('Error al conectar con la API de noticias: $e');
    }
  }
}
