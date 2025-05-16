import 'package:dio/dio.dart';
import 'package:kgaona/constants/constantes.dart';
import 'package:kgaona/domain/categoria.dart';
import 'package:kgaona/exceptions/api_exception.dart';

class CategoriaService {
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

  /// Obtiene todas las categorías desde la API
  Future<List<Categoria>> obtenerCategorias() async {
    try {
      final response = await _dio.get(ApiConstants.categoriaUrl);

      if (response.statusCode == 200) {
        final List<dynamic> categoriasJson = response.data;
        return categoriasJson
            .map<Categoria>(
              (json) => CategoriaMapper.fromMap(json as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw ApiException(
          ConstantesCategoria.mensajeError,
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ApiException(
        'Error al conectar con la API de categorías: $e',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }

  /// Crea una nueva categoría en la API
  Future<void> crearCategoria(Categoria categoria) async {
    try {
      final response = await _dio.post(
        ApiConstants.categoriaUrl,
        data: categoria.toMap(),
      );

      if (response.statusCode != 201) {
        throw ApiException(
          'Error al crear la categoría',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException('Error al conectar con la API de categorías: $e');
    }
  }

  /// Edita una categoría existente en la API
  Future<void> editarCategoria(Categoria categoria) async {
    try {
      final url = '${ApiConstants.categoriaUrl}/${categoria.id}';
      final response = await _dio.put(url, data: categoria.toMap());

      if (response.statusCode != 200) {
        throw ApiException(
          'Error al editar la categoría',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException('Error al conectar con la API de categorías: $e');
    }
  }

  /// Elimina una categoría de la API
  Future<void> eliminarCategoria(String id) async {
    try {
      final url = '${ApiConstants.categoriaUrl}/$id';
      final response = await _dio.delete(url);

      if (response.statusCode != 200 || response.statusCode != 201) {
        throw ApiException(
          'Error al eliminar la categoría',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException('Error al conectar con la API de categorías: $e');
    }
  }
}
