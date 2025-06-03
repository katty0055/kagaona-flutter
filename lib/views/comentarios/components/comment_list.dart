import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgaona/bloc/comentario/comentario_bloc.dart';
import 'package:kgaona/bloc/comentario/comentario_event.dart';
import 'package:kgaona/bloc/comentario/comentario_state.dart';
import 'package:kgaona/domain/comentario.dart';
import 'package:kgaona/helpers/snackbar_helper.dart';
import 'package:kgaona/views/comentarios/components/comment_card.dart';

class CommentList extends StatefulWidget {
  final String noticiaId;
  final Function(String, String) onResponderComentario;

  const CommentList({
    super.key,
    required this.noticiaId,
    required this.onResponderComentario,
  });

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  // Control de comentarios expandidos
  final Map<String, bool> _expandedComments = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<ComentarioBloc, ComentarioState>(
      listener: (context, state) {
        if (state is ComentarioError) {
          SnackBarHelper.manejarError(context, state.error);
        }
      },
      builder: (context, state) {
        if (state is ComentarioLoading) {
          return Center(
            child: CircularProgressIndicator(color: theme.colorScheme.primary),
          );
        } else if (state is ReaccionLoading) {
          return Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: theme.colorScheme.primary.withAlpha(13),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (state is ComentarioLoaded) {
          return _buildList(context, state.comentarios);
        } else if (state is ComentarioError) {
          return _buildErrorState(context);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildList(BuildContext context, List<Comentario> comentarios) {
    final theme = Theme.of(context);

    if (comentarios.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 48,
              color: theme.colorScheme.primary.withAlpha(127),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay comentarios que coincidan con tu búsqueda',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(177),
              ),
            ),
          ],
        ),
      );
    }
    final topLevelComments =
        comentarios.where((c) => c.idSubComentario == null).toList();
    final subComments = <String, List<Comentario>>{};
    for (var comment in comentarios.where((c) => c.idSubComentario != null)) {
      subComments.putIfAbsent(comment.idSubComentario!, () => []).add(comment);
    }
    return ListView.separated(
      itemCount: topLevelComments.length,
      itemBuilder: (context, index) {
        final comentario = topLevelComments[index];
        final commentSubComments = subComments[comentario.id] ?? [];
        final isExpanded = _expandedComments[comentario.id] ?? false;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommentCard(
              comentario: comentario,
              noticiaId: widget.noticiaId,
              onResponder: widget.onResponderComentario,
            ),
            if (commentSubComments.isNotEmpty) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _expandedComments[comentario.id!] = !isExpanded;
                    });
                  },
                  icon: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                  label: Text(
                    isExpanded
                        ? 'Ocultar respuestas'
                        : 'Ver ${commentSubComments.length} respuestas',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
              if (isExpanded)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        commentSubComments.map((subComment) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: CommentCard(
                              comentario: subComment,
                              noticiaId: widget.noticiaId,
                              onResponder: widget.onResponderComentario,
                            ),
                          );
                        }).toList(),
                  ),
                ),
            ],
          ],
        );
      },
      separatorBuilder:
          (_, __) =>
              Divider(color: theme.dividerColor.withAlpha(127), height: 16),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error, size: 48),
          const SizedBox(height: 16),
          Text(
            'Error al cargar comentarios',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed:
                () => context.read<ComentarioBloc>().add(
                  LoadComentarios(widget.noticiaId),
                ),
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
