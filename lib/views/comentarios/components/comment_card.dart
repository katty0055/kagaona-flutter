import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kgaona/bloc/comentario/comentario_bloc.dart';
import 'package:kgaona/bloc/comentario/comentario_event.dart';
import 'package:kgaona/domain/comentario.dart';
import 'package:kgaona/views/comentarios/components/subcomment_card.dart';

class CommentCard extends StatelessWidget {
  final Comentario comentario;
  final String noticiaId;
  final Function(String, String) onResponder;

  const CommentCard({
    super.key,
    required this.comentario,
    required this.noticiaId,
    required this.onResponder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String fechaHora = "Fecha no disponible";
    final DateTime fechaObj = DateTime.parse(comentario.fecha);
    fechaHora = DateFormat('dd/MM/yyyy HH:mm').format(fechaObj);
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: theme.colorScheme.surface, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comentario.autor,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(comentario.texto, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 8),
                Text(
                  fechaHora,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(153),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.thumb_up_outlined,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                      onPressed: () => _handleReaction(context, 'like'),
                      style: IconButton.styleFrom(
                        padding: const EdgeInsets.all(4),
                      ),
                    ),
                    Text(
                      comentario.likes.toString(),
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        Icons.thumb_down_outlined,
                        size: 18,
                        color: theme.colorScheme.error,
                      ),
                      onPressed: () => _handleReaction(context, 'dislike'),
                      style: IconButton.styleFrom(
                        padding: const EdgeInsets.all(4),
                      ),
                    ),
                    Text(
                      comentario.dislikes.toString(),
                      style: theme.textTheme.bodySmall,
                    ),
                    const Spacer(),
                    TextButton.icon(
                      icon: Icon(
                        Icons.reply,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                      label: Text(
                        'Responder',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed:
                          () => onResponder(
                            comentario.id ?? '',
                            comentario.autor,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (comentario.subcomentarios != null &&
              comentario.subcomentarios!.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(left: 16),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: theme.colorScheme.primary.withAlpha(77),
                    width: 2,
                  ),
                ),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comentario.subcomentarios!.length,
                itemBuilder:
                    (context, index) => SubcommentCard(
                      subcomentario: comentario.subcomentarios![index],
                      noticiaId: noticiaId,
                    ),
              ),
            ),
        ],
      ),
    );
  }

  void _handleReaction(BuildContext context, String tipoReaccion) {
    final comentarioBloc = context.read<ComentarioBloc>();
    comentarioBloc.add(
      AddReaccion(comentario.id ?? '', tipoReaccion, true, null),
    );
  }
}
