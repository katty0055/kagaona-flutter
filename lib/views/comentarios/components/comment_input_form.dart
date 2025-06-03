import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgaona/bloc/comentario/comentario_bloc.dart';
import 'package:kgaona/bloc/comentario/comentario_event.dart';
import 'package:kgaona/bloc/comentario/comentario_state.dart';
import 'package:kgaona/domain/comentario.dart';
import 'package:kgaona/helpers/snackbar_helper.dart';

class CommentInputForm extends StatelessWidget {
  final String noticiaId;
  final TextEditingController comentarioController;
  final String? respondingToId;
  final String? respondingToAutor;
  final VoidCallback onCancelarRespuesta;

  const CommentInputForm({
    super.key,
    required this.noticiaId,
    required this.comentarioController,
    required this.respondingToId,
    required this.respondingToAutor,
    required this.onCancelarRespuesta,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        if (respondingToId != null) _buildRespondingTo(context),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withAlpha(13),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: TextField(
            controller: comentarioController,
            decoration: InputDecoration(
              hintText:
                  respondingToId == null
                      ? 'Escribe tu comentario'
                      : 'Escribe tu respuesta...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: theme.colorScheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: theme.colorScheme.surface,
              contentPadding: const EdgeInsets.fromLTRB(16, 14, 60, 14),
              prefixIcon: Icon(
                respondingToId == null ? Icons.comment : Icons.reply,
                color: theme.colorScheme.primary,
              ),
              suffixIcon: Container(
                margin: const EdgeInsets.all(4),
                child: Material(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => _handleSubmit(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.send,
                        color: theme.colorScheme.onPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            maxLines: 2,
            style: theme.textTheme.bodyMedium,
            textInputAction: TextInputAction.newline,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildRespondingTo(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withAlpha(26),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.colorScheme.primary.withAlpha(77),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Respondiendo a $respondingToAutor',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 18, color: theme.colorScheme.primary),
            onPressed: onCancelarRespuesta,
            tooltip: 'Cancelar respuesta',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  void _handleSubmit(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (comentarioController.text.trim().isEmpty) {
      SnackBarHelper.mostrarInfo(
        context,
        mensaje: 'El comentario no puede estar vacío',
      );
      return;
    }
    final fecha = DateTime.now().toIso8601String();
    final bloc = context.read<ComentarioBloc>();
    if (respondingToId == null) {
      final nuevoComentario = Comentario(
        id: '',
        noticiaId: noticiaId,
        texto: comentarioController.text,
        fecha: fecha,
        autor: 'Usuario anónimo',
        likes: 0,
        dislikes: 0,
        subcomentarios: [],
        isSubComentario: false,
      );
      bloc.add(AddComentario(noticiaId, nuevoComentario));
    } else {
      final nuevoSubComentario = Comentario(
        id: '',
        noticiaId: noticiaId,
        texto: comentarioController.text,
        fecha: fecha,
        autor: 'Usuario anónimo',
        likes: 0,
        dislikes: 0,
        subcomentarios: [],
        isSubComentario: true,
        idSubComentario: respondingToId,
      );
      bloc.add(AddSubcomentario(nuevoSubComentario));
    }
    int totalComentariosActuales = 0;
    if (bloc.state is ComentarioLoaded) {
      final comentariosActuales = (bloc.state as ComentarioLoaded).comentarios;
      totalComentariosActuales = comentariosActuales.length;
      for (var comentario in comentariosActuales) {
        if (comentario.subcomentarios != null) {
          totalComentariosActuales += comentario.subcomentarios!.length;
        }
      }
    }
    final nuevoTotal = totalComentariosActuales + 1;
    bloc.add(ActualizarContadorComentarios(noticiaId, nuevoTotal));
    comentarioController.clear();
    onCancelarRespuesta();
    SnackBarHelper.mostrarExito(
      context,
      mensaje: 'Comentario agregado con éxito',
    );
  }
}
