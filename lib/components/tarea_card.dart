import 'package:flutter/material.dart';
import 'package:kgaona/domain/tarea.dart';
import 'package:kgaona/constants/constantes.dart';
import 'package:kgaona/theme/theme.dart';

class TaskCard extends StatelessWidget {
  final Tarea tarea;
  final String imageUrl;
  final String fechaLimiteDato;
  final VoidCallback onBackPressed;

  const TaskCard({
    super.key,
    required this.tarea,
    required this.imageUrl,
    required this.fechaLimiteDato,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool esUrgente = tarea.tipo != TareasConstantes.tareaTipoNormal;
    return Card(
      // No necesitamos especificar nada aquí, se usará imageCardTheme
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera con imagen y estado de la tarea
          Stack(
            children: [
              // Imagen sin caché, con fondo gris por defecto
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.network(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  // En caso de error, mostrar contenedor gris
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: theme.colorScheme.surface,
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 48,
                        color: theme.colorScheme.onSurface.withAlpha(177),
                      ),
                    ),
                  ),
                  // Mientras carga, mostrar contenedor gris
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 200,
                      color: theme.colorScheme.surface,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: theme.colorScheme.primary,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / 
                                loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Indicador de urgencia
              if (esUrgente)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error.withAlpha(204),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.priority_high,
                          color: theme.colorScheme.onError,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Urgente',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onError,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          
          // Contenido de la tarjeta
          Padding(
            padding: AppTheme.cardContentPadding(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título de la tarea
                Text(
                  tarea.titulo,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: esUrgente ? theme.colorScheme.error : null,
                  ),
                ),
                
                // Descripción si existe
                if (tarea.descripcion != null && tarea.descripcion!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      tarea.descripcion!,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                
                const SizedBox(height: 16),
                
                // Fecha límite
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${TareasConstantes.fechaLimite} $fechaLimiteDato',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Barra de acciones
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Estado de la tarea
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: tarea.completado 
                            ? theme.colorScheme.secondary.withAlpha(27)
                            : theme.colorScheme.primary.withAlpha(27),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            tarea.completado ? Icons.check_circle : Icons.pending,
                            color: tarea.completado 
                                ? theme.colorScheme.secondary
                                : theme.colorScheme.primary,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            tarea.completado ? 'Completada' : 'Pendiente',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: tarea.completado 
                                  ? theme.colorScheme.secondary
                                  : theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Botón volver
                    FilledButton.icon(
                      onPressed: onBackPressed,
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: const Text('Volver'),
                      style: AppTheme.cardActionButtonStyle(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}