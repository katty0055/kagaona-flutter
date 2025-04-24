import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:kgaona/constants.dart';
import 'package:kgaona/domain/noticia.dart';

class NoticiaRepository {
  final Dio _dio = Dio();

  NoticiaRepository() {
    // Agregar interceptor para registrar solicitudes y respuestas
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }

  Future<List<Noticia>> fetchNoticiasDIO() async {
    try {
      final response = await _dio.get(ConstantesNoticias.newsUrl);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((item) {
          return Noticia(
            id: item['_id'], // Asignar el id desde la respuesta
            titulo: item['titulo'] ?? 'Sin título',
            descripcion: item['descripcion'] ?? 'Sin descripción',
            fuente: item['fuente'] ?? 'Fuente desconocida',
            publicadaEl: DateTime.tryParse(item['publicadaEl'] ?? '') ?? DateTime.now(),
            imagenUrl: item['imagenUrl'] ?? 'https://via.placeholder.com/150',
          );
        }).toList();
      } else {
        throw Exception('Error al obtener las noticias: ${response.statusCode}');
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        // Respuesta HTTP recibida (por ejemplo, 400, 404, 500)
        final statusCode = dioError.response?.statusCode;
        final errorMessage = dioError.response?.data.toString() ?? 'Sin mensaje de error';
        throw Exception('Error HTTP $statusCode: $errorMessage');
      } else {
        // Sin respuesta HTTP, probablemente un error de red
        switch (dioError.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
            throw Exception('Error de conexión: Timeout al conectar con el servidor');
          case DioExceptionType.connectionError:
            throw Exception('Error de red: No se pudo establecer conexión con el servidor. Detalle: ${dioError.message}');
          case DioExceptionType.badCertificate:
            throw Exception('Error de certificado: El certificado del servidor no es válido');
          default:
            throw Exception('Error inesperado: ${dioError.message}');
        }
      }
    } catch (e, stackTrace) {
       log(stackTrace.toString(), name: 'NoticiaRepository 1', error: e);
      // Capturar cualquier otro error con stack trace para depuración
      throw Exception('Error al realizar la solicitud GET: $e');
    }
  }

  Future<void> crearNoticia(Noticia noticia) async {
    try {
      final response = await _dio.post(
        ConstantesNoticias.newsUrl,
        data: {
          "titulo": noticia.titulo,
          "descripcion": noticia.descripcion,
          "fuente": noticia.fuente,
          "publicadaEl": noticia.publicadaEl.toIso8601String(),
          "imagenUrl": noticia.imagenUrl,
        },
      );

      if (response.statusCode != 201) {
        throw Exception('Error al crear la noticia: ${response.statusCode}');
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        final statusCode = dioError.response?.statusCode;
        final errorMessage = dioError.response?.data.toString() ?? 'Sin mensaje de error';
        throw Exception('Error HTTP $statusCode: $errorMessage');
      } else {
        switch (dioError.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
            throw Exception('Error de conexión: Timeout al conectar con el servidor');
          case DioExceptionType.connectionError:
            throw Exception('Error de red: No se pudo establecer conexión con el servidor. Detalle: ${dioError.message}');
          case DioExceptionType.badCertificate:
            throw Exception('Error de certificado: El certificado del servidor no es válido');
          default:
            throw Exception('Error inesperado: ${dioError.message}');
        }
      }
    } catch (e, stackTrace) {
      log(stackTrace.toString(), name: 'NoticiaRepository', error: e);
      throw Exception('Error al realizar la solicitud POST: $e');
    }
  }

  Future<void> editarNoticia(String id, Noticia noticia) async {
    try {
      final url = '${ConstantesNoticias.newsUrl}/$id';
      final response = await _dio.put(
        url,
        data: {
          "titulo": noticia.titulo,
          "descripcion": noticia.descripcion,
          "fuente": noticia.fuente,
          "publicadaEl": noticia.publicadaEl.toIso8601String(),
          "imagenUrl": noticia.imagenUrl,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Error al editar la noticia: ${response.statusCode}');
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        final statusCode = dioError.response?.statusCode;
        final errorMessage = dioError.response?.data.toString() ?? 'Sin mensaje de error';
        throw Exception('Error HTTP $statusCode: $errorMessage');
      } else {
        switch (dioError.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
            throw Exception('Error de conexión: Timeout al conectar con el servidor');
          case DioExceptionType.connectionError:
            throw Exception('Error de red: No se pudo establecer conexión con el servidor. Detalle: ${dioError.message}');
          default:
            throw Exception('Error inesperado: ${dioError.message}');
        }
      }
    }
  }

  Future<void> eliminarNoticia(String id) async {
    try {
      final url = '${ConstantesNoticias.newsUrl}/$id';
      final response = await _dio.delete(url);

      if (response.statusCode != 200) {
        throw Exception('Error al eliminar la noticia: ${response.statusCode}');
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        final statusCode = dioError.response?.statusCode;
        final errorMessage = dioError.response?.data.toString() ?? 'Sin mensaje de error';
        throw Exception('Error HTTP $statusCode: $errorMessage');
      } else {
        switch (dioError.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
            throw Exception('Error de conexión: Timeout al conectar con el servidor');
          case DioExceptionType.connectionError:
            throw Exception('Error de red: No se pudo establecer conexión con el servidor. Detalle: ${dioError.message}');
          default:
            throw Exception('Error inesperado: ${dioError.message}');
        }
      }
    } catch (e, stackTrace) {
      log(stackTrace.toString(), name: 'NoticiaRepository', error: e);
      throw Exception('Error al realizar la solicitud DELETE: $e');
    }
  }
}