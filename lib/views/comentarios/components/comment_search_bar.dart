import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgaona/bloc/comentario/comentario_bloc.dart';
import 'package:kgaona/bloc/comentario/comentario_event.dart';

class CommentSearchBar extends StatelessWidget {
  final TextEditingController busquedaController;
  final VoidCallback onSearch;
  final String noticiaId;
  final bool ordenAscendente;
  final Function(bool) onOrdenChanged;

  const CommentSearchBar({
    super.key,
    required this.busquedaController,
    required this.onSearch,
    required this.noticiaId,
    required this.ordenAscendente,
    required this.onOrdenChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.primary.withAlpha(127),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Tooltip(
            message: ordenAscendente 
                ? 'Ordenar por más recientes' 
                : 'Ordenar por más antiguos',
            child: IconButton(
              onPressed: () => onOrdenChanged(!ordenAscendente),
              icon: Icon(
                ordenAscendente ? Icons.arrow_upward : Icons.arrow_downward,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              style: IconButton.styleFrom(
                padding: const EdgeInsets.all(12),
              ),
            ),
          ),
        ),
        Expanded(
          child: TextField(
            controller: busquedaController,
            decoration: InputDecoration(
              hintText: 'Buscar en comentarios...',
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
              suffixIcon: ValueListenableBuilder<TextEditingValue>(
                valueListenable: busquedaController,
                builder: (context, value, child) {
                  return value.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: theme.colorScheme.primary),
                          tooltip: 'Limpiar búsqueda',
                          onPressed: () {
                            busquedaController.clear();
                            context.read<ComentarioBloc>()
                              .add(LoadComentarios(noticiaId));
                          },
                        )
                      : const SizedBox.shrink();
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.colorScheme.primary.withAlpha(127)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 8),
          child: FilledButton(
            onPressed: onSearch,
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            child: const Text('Buscar'),
          ),
        ),
      ],
    );
  }
}