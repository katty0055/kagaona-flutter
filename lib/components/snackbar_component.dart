import 'package:flutter/material.dart';

/// Componente que proporciona la configuración visual del SnackBar
class SnackBarComponent {
  /// Crea y retorna un SnackBar con un estilo consistente para toda la aplicación
  static SnackBar crear({
    required BuildContext context,
    required String mensaje,
    required Color color,
    required Duration duracion,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    final theme = Theme.of(context);
    return SnackBar(
      content: Text(
        mensaje,
        style: theme.textTheme.bodyMedium?.copyWith(color:theme.colorScheme.onPrimary),
      ),
      backgroundColor: color,
      duration: duracion,
      action:
          onAction != null && actionLabel != null
              ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onAction,
              )
              : null,
      behavior: SnackBarBehavior.fixed,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      elevation: 0, // Sin sombra
    );
  }
}
