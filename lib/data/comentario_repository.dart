import 'package:kgaona/api/service/comentario_service.dart';
import 'package:kgaona/constants/constantes.dart';
import 'package:kgaona/data/base_repository.dart';
import 'package:kgaona/domain/comentario.dart';
import 'package:kgaona/helpers/secure_storage_service.dart';
import 'package:watch_it/watch_it.dart';

class ComentarioRepository extends BaseRepository<Comentario> {
  final _comentarioService = di<ComentarioService>();
  final _secureStorageService = di<SecureStorageService>();

  @override
  void validarEntidad(Comentario comentario) {
    validarNoVacio(comentario.texto, ValidacionConstantes.comentarioTexto);
    validarNoVacio(comentario.autor, ValidacionConstantes.comentarioAutor);
    validarNoVacio(comentario.noticiaId, ValidacionConstantes.noticiaId);
  }

  void validarSubcomentario(Comentario subcomentario) {
    validarEntidad(subcomentario);
  }

  Future<List<Comentario>> obtenerComentariosPorNoticia(
    String noticiaId,
  ) async {
    return manejarExcepcion(() async {
      validarNoVacio(noticiaId, ValidacionConstantes.noticiaId);
      final comentarios = await _comentarioService.obtenerComentariosPorNoticia(
        noticiaId,
      );
      return comentarios;
    }, mensajeError: ComentarioConstantes.mensajeError);
  }

  Future<Comentario> agregarComentario(Comentario comentario) async {
    return manejarExcepcion(() async {
      validarEntidad(comentario);
      comentario = comentario.copyWith(
        autor: await _secureStorageService.getUserEmail(),
      );
      final response = await _comentarioService.agregarComentario(comentario);
      return response;
    }, mensajeError: ComentarioConstantes.errorCreated);
  }

  Future<Comentario> reaccionarComentario(
    String comentarioId,
    String tipo,
  ) async {
    return manejarExcepcion(() async {
      validarNoVacio(comentarioId, ValidacionConstantes.comentarioId);
      Comentario response;
      if (comentarioId.contains('sub_')) {
        response = await _comentarioService.reaccionarSubComentario(
          subComentarioId: comentarioId,
          tipoReaccion: tipo,
        );
      } else {
        response = await _comentarioService.reaccionarComentarioPrincipal(
          comentarioId: comentarioId,
          tipoReaccion: tipo,
        );
      }
      return response;
    }, mensajeError: ComentarioConstantes.errorReaccionarComentario);
  }

  Future<Comentario> agregarSubcomentario(Comentario subcomentario) async {
    return manejarExcepcion(() async {
      validarSubcomentario(subcomentario);
      final comentarioPadreId = subcomentario.idSubComentario!;
      subcomentario = subcomentario.copyWith(
        id:
            'sub_${DateTime.now().millisecondsSinceEpoch}_${subcomentario.texto.hashCode}',
        autor: await _secureStorageService.getUserEmail(),
      );
      final response = await _comentarioService.agregarSubcomentario(
        comentarioId: comentarioPadreId,
        subComentario: subcomentario,
      );
      return response;
    }, mensajeError: ComentarioConstantes.errorCreatedSub);
  }

  Future<void> eliminarComentariosPorNoticia(String noticiaId) async {
    return manejarExcepcion(() async {
      validarNoVacio(noticiaId, ValidacionConstantes.noticiaId);
      await _comentarioService.eliminarComentariosPorNoticia(noticiaId);
    }, mensajeError: ComentarioConstantes.errorEliminarComentarios);
  }
}
