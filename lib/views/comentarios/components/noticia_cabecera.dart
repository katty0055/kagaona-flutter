import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kgaona/constants/constantes.dart';
import 'package:kgaona/domain/noticia.dart';

class NoticiaCabecera extends StatelessWidget {
  final Noticia noticia;
  final String categoriaNombre;

  const NoticiaCabecera({
    super.key,
    required this.noticia,
    required this.categoriaNombre,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Asegurar que los contadores nunca sean nulos
    final contadorComentarios = noticia.contadorComentarios ?? 0;
    final contadorReportes = noticia.contadorReportes ?? 0;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Text(
                categoriaNombre.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              noticia.titulo,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),            
            const SizedBox(height: 12),            
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                noticia.urlImagen.isNotEmpty
                    ? noticia.urlImagen
                    : 'https://picsum.photos/200/300',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: theme.colorScheme.onSurface.withAlpha(77),
                      size: 64,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              noticia.descripcion,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),            
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  noticia.fuente,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: theme.colorScheme.onSurface.withAlpha(179),
                ),
                const SizedBox(width: 4),
                Text(
                  _formatDate(noticia.publicadaEl),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(179),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.comment_outlined,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$contadorComentarios comentarios',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.flag_outlined,
                    size: 16,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$contadorReportes reportes',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat(AppConstantes.formatoFecha).format(date);
  }
}