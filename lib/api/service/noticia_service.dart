import 'package:dio/dio.dart';
import 'package:kgaona/constants/constants.dart';
import 'package:kgaona/domain/noticia.dart';
import 'package:kgaona/exceptions/api_exception.dart';

class NoticiaService {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(
        milliseconds: (ConstantesCategoria.timeoutSeconds * 1000),
      ),
      receiveTimeout: const Duration(
        milliseconds: (ConstantesCategoria.timeoutSeconds * 1000),
      ),
    ),
  );

  /// Obtiene todas las noticias desde la API
  Future<List<Noticia>> obtenerNoticias() async {
    try {
      final response = await _dio.get(ApiConstants.newsUrl);

      if (response.statusCode == 200) {
        final List<dynamic> noticiasJson = response.data;
        return noticiasJson.map((item) => Noticia.fromJson(item)).toList();
      } else {
        throw ApiException(
          'Error al obtener las noticias',
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
  Future<void> crearNoticia(Map<String, dynamic> noticia) async {
    try {
      final response = await _dio.post(ApiConstants.newsUrl, data: noticia);

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
  Future<void> editarNoticia(String id, Map<String, dynamic> noticia) async {
    try {
      final url = '${ApiConstants.newsUrl}/$id';
      final response = await _dio.put(url, data: noticia);

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
      final url = '${ApiConstants.newsUrl}/$id';
      final response = await _dio.delete(url);

      if (response.statusCode != 200) {
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
