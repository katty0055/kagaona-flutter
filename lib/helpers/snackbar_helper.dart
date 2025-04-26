import 'package:flutter/material.dart';
import 'package:kgaona/components/snackbar_component.dart';

/// Helper para mostrar SnackBars de manera consistente en toda la aplicación
class SnackBarHelper {
  /// Muestra un SnackBar de éxito con un mensaje específico
  static void mostrarExito(
    BuildContext context, {
    required String mensaje,
    Duration duracion = const Duration(seconds: 2),
  }) {
    _mostrarSnackBar(
      context,
      mensaje: mensaje,
      color: Colors.green,
      duracion: duracion,
    );
  }

  /// Muestra un SnackBar de error basado en una excepción
  static void mostrarError(
    BuildContext context, {
    required String mensaje,
    required snackBarColor,
    Duration duracion = const Duration(seconds: 4),
  }) {
    _mostrarSnackBar(
      context,
      mensaje: mensaje,
      color: snackBarColor,
      duracion: duracion,
    );
  }

  /// Muestra un SnackBar informativo
  static void mostrarInfo(
    BuildContext context, {
    required String mensaje,
    Duration duracion = const Duration(seconds: 3),
  }) {
    _mostrarSnackBar(
      context,
      mensaje: mensaje,
      color: Colors.blue,  // Color informativo
      duracion: duracion,
    );
  }

  /// Método privado para mostrar el SnackBar con parámetros personalizados
  static void _mostrarSnackBar(
    BuildContext context, {
    required String mensaje,
    required Color color,
    required Duration duracion,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    // Verificar si el contexto todavía está montado
    if (!context.mounted) return;

    // Cerrar cualquier SnackBar existente
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Crear el SnackBar usando el componente y mostrarlo
    final snackBar = SnackBarComponent.crear(
      mensaje: mensaje,
      color: color,
      duracion: duracion,
      onAction: onAction,
      actionLabel: actionLabel,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

