import 'package:flutter/material.dart';
import 'package:kgaona/domain/categoria.dart';

class CategoriaCard extends StatelessWidget {
  final Categoria categoria;
  final VoidCallback onEdit;

  const CategoriaCard({
    super.key,
    required this.categoria,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Tooltip(
        message: 'Editar categoría',
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8.0, 
            vertical: 0.0,   
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              categoria.imagenUrl,
              width: 60,      
              height: 60,    
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: theme.colorScheme.surface,
                  child: Icon(
                    Icons.broken_image,
                    color: theme.colorScheme.onSurface.withAlpha(127),
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 60,
                  height: 60,
                  color: theme.colorScheme.surface,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                );
              },
            ),
          ),
          title: Text(
            categoria.nombre,
            style: theme.textTheme.titleMedium, 
          ),
          subtitle: Text(
            categoria.descripcion,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium, 
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                onPressed: onEdit,
                style: IconButton.styleFrom(
                  padding: const EdgeInsets.all(4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          onTap: onEdit,
        ),
      ),
    );
  }
}
