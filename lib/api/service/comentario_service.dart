import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kgaona/api/service/base_service.dart';
import 'package:kgaona/constants/constantes.dart';
import 'package:kgaona/core/api_config.dart';
import 'package:kgaona/domain/comentario.dart';
import 'package:kgaona/exceptions/api_exception.dart';

class ComentarioService extends BaseService {
  /// Obtiene todos los comentarios de una noticia específica
  Future<List<Comentario>> obtenerComentariosPorNoticia(
    String noticiaId,
  ) async {
    final endpoint = ApiConfig.comentariosEndpoint;
    final List<dynamic> comentariosJson = await get<List<dynamic>>(
      endpoint,
      errorMessage: ConstantesComentarios.mensajeError,
    );

    // Filtrar solo los comentarios para la noticia específica
    return comentariosJson
        .where((json) => json['noticiaId'] == noticiaId)
        .map<Comentario>(
          (json) => ComentarioMapper.fromMap(json as Map<String, dynamic>),
        )
        .toList();
  }

  /// Agrega un nuevo comentario a una noticia
  Future<void> agregarComentario(Comentario comentario) async {
    await post(
      ApiConfig.comentariosEndpoint,
      data: comentario.toMap(),
      errorMessage: 'Error al agregar el comentario',
    );
  }

  /// Calcula el número de comentarios para una noticia específica
  Future<int> obtenerNumeroComentarios(String noticiaId) async {
    // Obtenemos todos los comentarios de la noticia
    final comentarios = await obtenerComentariosPorNoticia(noticiaId);
    
    int contador = comentarios.length;
    
    // Sumamos también los subcomentarios
    for (var comentario in comentarios) {
      if (comentario.subcomentarios != null) {
        contador += comentario.subcomentarios!.length;
      }
    }
    
    return contador;
  }

  /// Registra una reacción (like o dislike) a un comentario o subcomentario
  Future<void> reaccionarComentario(
    String comentarioId,
    String tipo,
    bool incrementar,
    {String? comentarioPadreId}
  ) async {
    try {
      // Primero obtenemos todos los comentarios
      final List<dynamic> comentariosJson = await get<List<dynamic>>(
        ApiConfig.comentariosEndpoint,
        errorMessage: 'Error al obtener comentarios para reaccionar',
      );
      
      bool encontrado = false;

      // Búsqueda en comentarios principales
      for (final comentario in comentariosJson) {
        if (comentario['id'] == comentarioId) {
          final comentarioActualizado = _aplicarReaccion(comentario, tipo, incrementar);
          
          await put(
            '${ApiConfig.comentariosEndpoint}/$comentarioId',
            data: comentarioActualizado,
            errorMessage: 'Error al registrar la reacción',
          );
          encontrado = true;
          break;
        }

        // Búsqueda en subcomentarios
        final subcomentarios = _parsearSubcomentarios(comentario['subcomentarios']);
        for (int i = 0; i < subcomentarios.length; i++) {
          final sub = subcomentarios[i];
          
          // Verificamos tanto el campo id como idSubComentario
          if ((sub['id'] != null && sub['id'] == comentarioId) || 
              (sub['idSubComentario'] != null && sub['idSubComentario'] == comentarioId)) {
            
            final subActualizado = _aplicarReaccion(sub, tipo, incrementar);
            subcomentarios[i] = subActualizado;
            
            final comentarioActualizado = {...comentario, 'subcomentarios': subcomentarios};
            
            await put(
              '${ApiConfig.comentariosEndpoint}/${comentario['id']}',
              data: comentarioActualizado,
              errorMessage: 'Error al registrar la reacción en el subcomentario',
            );
            encontrado = true;
            break;
          }
        }
        if (encontrado) break;
      }

      if (!encontrado) {
        throw ApiException('Comentario o subcomentario no encontrado');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      debugPrint('Error en reacción: $e');
      throw ApiException('Error procesando reacción: ${e.toString()}');
    }
  }

  /// Agrega un subcomentario a un comentario existente
  Future<void> agregarSubcomentario(Comentario subcomentario) async {
    try {
      if (subcomentario.idSubComentario == null || subcomentario.idSubComentario!.isEmpty) {
        throw ApiException('El ID del comentario padre es requerido');
      }

      if (!subcomentario.isSubComentario) {
        throw ApiException('El comentario debe marcarse como subcomentario');
      }

      // Obtenemos el comentario padre directamente
      final comentarioPadreJson = await get<Map<String, dynamic>>(
        '${ApiConfig.comentariosEndpoint}/${subcomentario.idSubComentario}',
        errorMessage: 'Error al obtener el comentario padre',
      );
      
      // Verificar que el comentario padre no sea ya un subcomentario
      if (comentarioPadreJson['isSubComentario'] == true) {
        throw ApiException('No se pueden añadir subcomentarios a otros subcomentarios');
      }
      
      // Preparamos el subcomentario para agregarlo
      Map<String, dynamic> subcomentarioMap = subcomentario.toMap();
      
      // Generamos un ID único para el subcomentario si no tiene uno
      if (subcomentario.id == null || subcomentario.id!.isEmpty) {
        subcomentarioMap['id'] = 'sub_${DateTime.now().millisecondsSinceEpoch}_${(subcomentario.texto.hashCode).abs()}';
      }
      
      // Obtenemos la lista actual de subcomentarios
      List<dynamic> subcomentarios = _parsearSubcomentarios(comentarioPadreJson['subcomentarios']);
      
      // Agregamos el nuevo subcomentario
      subcomentarios.add(subcomentarioMap);
      
      // Actualizamos el comentario padre en la API
      final comentarioPadreActualizado = {...comentarioPadreJson, 'subcomentarios': subcomentarios};
      await put(
        '${ApiConfig.comentariosEndpoint}/${subcomentario.idSubComentario}',
        data: comentarioPadreActualizado,
        errorMessage: 'Error al agregar el subcomentario',
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error agregando subcomentario: ${e.toString()}');
    }
  }

  // Métodos auxiliares privados
  
  /// Convierte los subcomentarios a una lista manejable
  List<dynamic> _parsearSubcomentarios(dynamic subcomentarios) {
    if (subcomentarios is String) {
      try {
        return jsonDecode(subcomentarios) as List<dynamic>;
      } catch (e) {
        return [];
      }
    }
    return List<dynamic>.from(subcomentarios ?? []);
  }

  /// Aplica una reacción (like/dislike) a un comentario o subcomentario
  Map<String, dynamic> _aplicarReaccion(Map<String, dynamic> comentario, String tipo, bool incrementar) {
    final clave = tipo == 'like' ? 'likes' : 'dislikes';
    final valorActual = comentario[clave] ?? 0;
    
    return {
      ...comentario, 
      clave: incrementar 
        ? valorActual + 1 
        : (valorActual > 0 ? valorActual - 1 : 0)
    };
  }
}
