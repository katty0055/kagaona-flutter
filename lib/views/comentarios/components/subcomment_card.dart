import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kgaona/bloc/comentario/comentario_bloc.dart';
import 'package:kgaona/bloc/comentario/comentario_event.dart';
import 'package:kgaona/domain/comentario.dart';

class SubcommentCard extends StatelessWidget {
  final Comentario subcomentario;
  final String noticiaId;

  const SubcommentCard({
    super.key,
    required this.subcomentario,
    required this.noticiaId,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String fechaHora = "Fecha no disponible";
      final DateTime fechaObj = DateTime.parse(subcomentario.fecha);
      fechaHora = DateFormat('dd/MM/yyyy HH:mm').format(fechaObj);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subcomentario.autor,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subcomentario.texto, 
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            fechaHora,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(153),
              fontStyle: FontStyle.italic,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(
                  Icons.thumb_up_outlined,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                onPressed: () => _handleReaction(context, 'like'),
                style: IconButton.styleFrom(
                  padding: const EdgeInsets.all(4),
                ),
              ),
              Text(
                subcomentario.likes.toString(),
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  Icons.thumb_down_outlined,
                  size: 16,
                  color: theme.colorScheme.error,
                ),
                onPressed: () => _handleReaction(context, 'dislike'),
                style: IconButton.styleFrom(
                  padding: const EdgeInsets.all(4),
                ),
              ),
              Text(
                subcomentario.dislikes.toString(),
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  void _handleReaction(BuildContext context, String tipoReaccion) {
    final comentarioBloc = context.read<ComentarioBloc>();
    final String currentNoticiaId = noticiaId;    
    String comentarioId = '';
    String? padreId;
    if (subcomentario.id != null && subcomentario.id!.isNotEmpty) {
      comentarioId = subcomentario.id!;
      if (subcomentario.idSubComentario != null && subcomentario.idSubComentario!.isNotEmpty) {
        padreId = subcomentario.idSubComentario;
      }
    } 
    else if (subcomentario.idSubComentario != null && subcomentario.idSubComentario!.isNotEmpty) {
      comentarioId = subcomentario.idSubComentario!;
    }
    comentarioBloc.add(
      AddReaccion(
        comentarioId,
        tipoReaccion,
        true,
        padreId,
      ),
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      comentarioBloc.add(
        LoadComentarios(currentNoticiaId),
      );
    });
  }
}
