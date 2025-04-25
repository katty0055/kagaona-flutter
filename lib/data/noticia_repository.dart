import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:kgaona/constants.dart';
import 'package:kgaona/domain/noticia.dart';
import 'package:kgaona/exceptions/api_exception.dart';

class NoticiaRepository {
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

  NoticiaRepository() {
    // Agregar interceptor para registrar solicitudes y respuestas
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  Future<List<Noticia>> fetchNoticiasDIO() async {
    try {
      final response = await _dio.get(ApiConstants.newsUrl);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((item) => Noticia.fromJson(item)).toList();
      } else {
        throw ApiException(
          'Error al obtener las noticias',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (dioError) {
      // Manejo específico de errores HTTP
      if (dioError.response != null) {
        final statusCode = dioError.response?.statusCode;
        
        switch (statusCode) {
          case 400:
            throw ApiException(ConstantesNoticias.mensajeError, statusCode: statusCode);
          case 401:
            throw ApiException('No autorizado', statusCode: statusCode);
          case 404:
            throw ApiException('Noticias no encontradas', statusCode: statusCode);
          case 500:
            throw ApiException('Error del servidor', statusCode: statusCode);
          default:
            final errorMessage = dioError.response?.data.toString() ?? 'Sin mensaje de error';
            throw ApiException('Error HTTP $statusCode: $errorMessage', statusCode: statusCode);
        }
      } else {
        // Manejo de errores de conexión/red
        switch (dioError.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
            throw ApiException(ConstantesCategoria.errorTimeout, statusCode: null);
          case DioExceptionType.connectionError:
            throw ApiException(
              'Error de red: No se pudo establecer conexión con el servidor',
              statusCode: null,
            );
          case DioExceptionType.badCertificate:
            throw ApiException(
              'Error de certificado: El certificado del servidor no es válido',
              statusCode: null,
            );
          default:
            throw ApiException('Error inesperado: ${dioError.message}', statusCode: null);
        }
      }
    } catch (e, stackTrace) {
      log(stackTrace.toString(), name: 'NoticiaRepository', error: e);
      // Cualquier otro error no relacionado con Dio
      throw ApiException('Error al realizar la solicitud GET: $e');
    }
  }

  Future<void> crearNoticia(Noticia noticia) async {
    try {
      final response = await _dio.post(
        ApiConstants.newsUrl,
        data: {
          "titulo": noticia.titulo,
          "descripcion": noticia.descripcion,
          "fuente": noticia.fuente,
          "publicadaEl": noticia.publicadaEl.toIso8601String(),
          "imagenUrl": noticia.imagenUrl,
          "categoriaId": noticia.categoriaId, // Añadimos el categoriaId en la creación
        },
      );

      if (response.statusCode != 201) {
        throw ApiException(
          'Error al crear la noticia',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (dioError) {
      // Manejo específico de errores HTTP
      if (dioError.response != null) {
        final statusCode = dioError.response?.statusCode;
        
        switch (statusCode) {
          case 400:
            throw ApiException(ConstantesNoticias.mensajeError, statusCode: statusCode);
          case 401:
            throw ApiException('No autorizado', statusCode: statusCode);
          case 404:
            throw ApiException('Noticias no encontradas', statusCode: statusCode);
          case 500:
            throw ApiException('Error del servidor', statusCode: statusCode);
          default:
            final errorMessage = dioError.response?.data.toString() ?? 'Sin mensaje de error';
            throw ApiException('Error HTTP $statusCode: $errorMessage', statusCode: statusCode);
        }
      } else {
        // Manejo de errores de conexión/red
        switch (dioError.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
            throw ApiException(ConstantesCategoria.errorTimeout, statusCode: null);
          case DioExceptionType.connectionError:
            throw ApiException(
              'Error de red: No se pudo establecer conexión con el servidor',
              statusCode: null,
            );
          case DioExceptionType.badCertificate:
            throw ApiException(
              'Error de certificado: El certificado del servidor no es válido',
              statusCode: null,
            );
          default:
            throw ApiException('Error inesperado: ${dioError.message}', statusCode: null);
        }
      }
    } catch (e, stackTrace) {
      log(stackTrace.toString(), name: 'NoticiaRepository', error: e);
      // Cualquier otro error no relacionado con Dio
      throw ApiException('Error al realizar la solicitud POST: $e');
    }
  }

  Future<void> editarNoticia(String id, Noticia noticia) async {
    try {
      final url = '${ApiConstants.newsUrl}/$id';
      final response = await _dio.put(
        url,
        data: {
          "titulo": noticia.titulo,
          "descripcion": noticia.descripcion,
          "fuente": noticia.fuente,
          "publicadaEl": noticia.publicadaEl.toIso8601String(),
          "imagenUrl": noticia.imagenUrl,
          "categoriaId": noticia.categoriaId, // Añadimos el categoriaId en la edición
        },
      );

      if (response.statusCode != 200) {
        throw ApiException(
          'Error al editar la noticia',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (dioError) {
      // Manejo específico de errores HTTP
      if (dioError.response != null) {
        final statusCode = dioError.response?.statusCode;
        
        switch (statusCode) {
          case 400:
            throw ApiException(ConstantesNoticias.mensajeError, statusCode: statusCode);
          case 401:
            throw ApiException('No autorizado', statusCode: statusCode);
          case 404:
            throw ApiException('Noticia no encontrada', statusCode: statusCode);
          case 500:
            throw ApiException('Error del servidor', statusCode: statusCode);
          default:
            final errorMessage = dioError.response?.data.toString() ?? 'Sin mensaje de error';
            throw ApiException('Error HTTP $statusCode: $errorMessage', statusCode: statusCode);
        }
      } else {
        // Manejo de errores de conexión/red
        switch (dioError.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
            throw ApiException(ConstantesCategoria.errorTimeout, statusCode: null);
          case DioExceptionType.connectionError:
            throw ApiException(
              'Error de red: No se pudo establecer conexión con el servidor',
              statusCode: null,
            );
          case DioExceptionType.badCertificate:
            throw ApiException(
              'Error de certificado: El certificado del servidor no es válido',
              statusCode: null,
            );
          default:
            throw ApiException('Error inesperado: ${dioError.message}', statusCode: null);
        }
      }
    } catch (e, stackTrace) {
      log(stackTrace.toString(), name: 'NoticiaRepository', error: e);
      throw ApiException('Error al realizar la solicitud PUT: $e');
    }
  }

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
    } on DioException catch (dioError) {
      // Manejo específico de errores HTTP
      if (dioError.response != null) {
        final statusCode = dioError.response?.statusCode;
        
        switch (statusCode) {
          case 400:
            throw ApiException(ConstantesNoticias.mensajeError, statusCode: statusCode);
          case 401:
            throw ApiException('No autorizado', statusCode: statusCode);
          case 404:
            throw ApiException('Noticia no encontrada', statusCode: statusCode);
          case 500:
            throw ApiException('Error del servidor', statusCode: statusCode);
          default:
            final errorMessage = dioError.response?.data.toString() ?? 'Sin mensaje de error';
            throw ApiException('Error HTTP $statusCode: $errorMessage', statusCode: statusCode);
        }
      } else {
        // Manejo de errores de conexión/red
        switch (dioError.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
            throw ApiException(ConstantesCategoria.errorTimeout, statusCode: null);
          case DioExceptionType.connectionError:
            throw ApiException(
              'Error de red: No se pudo establecer conexión con el servidor',
              statusCode: null,
            );
          case DioExceptionType.badCertificate:
            throw ApiException(
              'Error de certificado: El certificado del servidor no es válido',
              statusCode: null,
            );
          default:
            throw ApiException('Error inesperado: ${dioError.message}', statusCode: null);
        }
      }
    } catch (e, stackTrace) {
      log(stackTrace.toString(), name: 'NoticiaRepository', error: e);
      throw ApiException('Error al realizar la solicitud DELETE: $e');
    }
  }

  // Método auxiliar para filtrar noticias por categoría
  Future<List<Noticia>> getNoticiasPorCategoria(String categoriaId) async {
    try {
      final noticias = await fetchNoticiasDIO();
      
      // Si el categoriaId es null o vacío, devolver todas las noticias
      if (categoriaId.isEmpty) {
        return noticias;
      }
      
      // Filtrar las noticias por la categoría seleccionada
      return noticias.where((noticia) => 
        noticia.categoriaId == categoriaId
      ).toList();
    } on DioException catch (dioError) {
      // Manejo específico de errores HTTP
      if (dioError.response != null) {
        final statusCode = dioError.response?.statusCode;
        
        switch (statusCode) {
          case 400:
            throw ApiException(ConstantesNoticias.mensajeError, statusCode: statusCode);
          case 401:
            throw ApiException('No autorizado', statusCode: statusCode);
          case 404:
            throw ApiException('Noticias no encontradas', statusCode: statusCode);
          case 500:
            throw ApiException('Error del servidor', statusCode: statusCode);
          default:
            final errorMessage = dioError.response?.data.toString() ?? 'Sin mensaje de error';
            throw ApiException('Error HTTP $statusCode: $errorMessage', statusCode: statusCode);
        }
      } else {
        // Manejo de errores de conexión/red
        switch (dioError.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
            throw ApiException(ConstantesCategoria.errorTimeout, statusCode: null);
          case DioExceptionType.connectionError:
            throw ApiException(
              'Error de red: No se pudo establecer conexión con el servidor',
              statusCode: null,
            );
          case DioExceptionType.badCertificate:
            throw ApiException(
              'Error de certificado: El certificado del servidor no es válido',
              statusCode: null,
            );
          default:
            throw ApiException('Error inesperado: ${dioError.message}', statusCode: null);
        }
      }
    } catch (e, stackTrace) {
      log(stackTrace.toString(), name: 'NoticiaRepository', error: e);
      throw ApiException('Error al buscar noticias por categoría: $e');
    }
  }
}
