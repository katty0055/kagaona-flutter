import 'package:dart_mappable/dart_mappable.dart';
import 'package:kgaona/api/service/base_service.dart';
import 'package:kgaona/constants/constantes.dart';
import 'package:kgaona/domain/comentario.dart';

class ComentarioService extends BaseService {
  final _url = ApiConstantes.comentariosEndpoint;

  Future<List<Comentario>> obtenerComentariosPorNoticia(
    String noticiaId,
  ) async {
    final List<dynamic> comentariosJson = await get<List<dynamic>>(
      '$_url?noticiaId=$noticiaId',
      errorMessage: ComentarioConstantes.mensajeError,
    );
    return comentariosJson
        .map<Comentario>(
          (json) => ComentarioMapper.fromMap(json as Map<String, dynamic>),
        )
        .toList();
  }

  Future<Comentario> agregarComentario(Comentario comentario) async {
    final response = await post(
      _url,
      data: comentario.toMap(),
      errorMessage: ComentarioConstantes.errorCreated,
    );
    return ComentarioMapper.fromMap(response);
  }

  Future<int> obtenerNumeroComentarios(String noticiaId) async {
    final comentarios = await obtenerComentariosPorNoticia(noticiaId);
    int contador = comentarios.length;
    for (var comentario in comentarios) {
      if (comentario.subcomentarios != null) {
        contador += comentario.subcomentarios!.length;
      }
    }
    return contador;
  }

  Future<Comentario> obtenerComentarioPorId({
    required String comentarioId,
  }) async {
    final response = await get(
      '$_url/$comentarioId',
      errorMessage: ComentarioConstantes.errorNotFound,
    );
    return MapperContainer.globals.fromMap<Comentario>(response);
  }

  Future<Comentario> reaccionarComentarioPrincipal({
    required String comentarioId,
    required String tipoReaccion,
  }) async {
    final comentario = await obtenerComentarioPorId(comentarioId: comentarioId);
    final comentarioActualizado = _actualizarContadores(
      tipoReaccion: tipoReaccion,
      comentario: comentario,
    );
    final response = await put(
      '$_url/$comentarioId',
      data: comentarioActualizado.toMap(),
      errorMessage: ComentarioConstantes.errorReaccionarComentario,
    );
    return ComentarioMapper.fromMap(response);
  }

  Future<Comentario?> buscarPorSubComentarioId({
    required String subcomentarioId,
  }) async {
    final response = await get(
      '$_url?subcomentarios.id=$subcomentarioId',
      errorMessage: ComentarioConstantes.errorGetComentario,
    );
    return ComentarioMapper.fromMap(response[0] as Map<String, dynamic>);
  }

  Future<Comentario> reaccionarSubComentario({
    required String subComentarioId,
    required String tipoReaccion,
  }) async {
    Comentario? comentario = await buscarPorSubComentarioId(
      subcomentarioId: subComentarioId,
    );
    Comentario subComentario;
    if (comentario?.subcomentarios != null) {
      subComentario = (comentario?.subcomentarios)!.firstWhere(
        (sub) => sub.id == subComentarioId,
      );
      subComentario = _actualizarContadores(
        tipoReaccion: tipoReaccion,
        comentario: subComentario,
      );
      comentario = comentario?.copyWith(
        subcomentarios: [
          ...comentario.subcomentarios!.map((sub) {
            if (sub.id == subComentarioId) {
              return subComentario;
            }
            return sub;
          }),
        ],
      );
    }
    final response = await put(
      '$_url/${comentario?.id}',
      data: comentario?.toMap(),
      errorMessage: ComentarioConstantes.errorReaccionarSubComentario,
    );
    return ComentarioMapper.fromMap(response);
  }

  Comentario _actualizarContadores({
    Comentario? comentario,
    required String tipoReaccion,
  }) {
    int currentLikes = comentario!.likes;
    int currentDislikes = comentario.dislikes;
    if (tipoReaccion == 'like') {
      currentLikes++;
    } else if (tipoReaccion == 'dislike') {
      currentDislikes++;
    }
    return comentario = comentario.copyWith(
      likes: currentLikes,
      dislikes: currentDislikes,
    );
  }

  Future<Comentario> agregarSubcomentario({
    required String comentarioId,
    required Comentario subComentario,
  }) async {
    final comentario = await obtenerComentarioPorId(comentarioId: comentarioId);
    final subComentariosActualizados = [
      ...?comentario.subcomentarios,
      subComentario,
    ];
    final comentarioActualizado = comentario.copyWith(
      subcomentarios: subComentariosActualizados,
    );
    final response = await put(
      '$_url/$comentarioId',
      data: comentarioActualizado.toMap(),
      errorMessage: ComentarioConstantes.errorCreatedSub,
    );
    return ComentarioMapper.fromMap(response);
  }

  Future<void> eliminarComentariosPorNoticia(String noticiaId) async {
    final comentarios = await obtenerComentariosPorNoticia(noticiaId);
    for (final comentario in comentarios) {
      if (comentario.id != null) {
        await delete(
          '$_url/${comentario.id}',
          errorMessage: ComentarioConstantes.errorDeleteComentario,
        );
      }
    }
  }
}
