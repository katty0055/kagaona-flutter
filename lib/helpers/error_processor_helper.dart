import 'package:flutter/material.dart';
import 'package:kgaona/exceptions/api_exception.dart';
import 'package:kgaona/helpers/error_helper.dart';
import 'package:kgaona/helpers/snackbar_helper.dart';

class ErrorProcessorHelper {
  static ErrorInfo procesarError(
    Object e, {
    String mensajePredeterminado = 'Error desconocido',
  }) {
    Color color = Colors.grey;
    String mensaje = e.toString();

    if (e is ApiException) {
      final errorData = ErrorHelper.getErrorMessageAndColor(e.statusCode);
      mensaje = mensajePredeterminado.isEmpty? errorData['message']: mensajePredeterminado;
      color = errorData['color'];
    }

    return ErrorInfo(mensaje: mensaje, color: color);
  }

  static void manejarError(
    BuildContext context,
    Object e, {
    String mensajePredeterminado = 'Error desconocido',
  }) {
    if (!context.mounted) return;

    final errorInfo = procesarError(
      e,
      mensajePredeterminado: mensajePredeterminado,
    );

    SnackBarHelper.mostrarError(
      context,
      mensaje: errorInfo.mensaje,
      snackBarColor: errorInfo.color,
    );
  }
}

/// Modelo de información de error
class ErrorInfo {
  final String mensaje;
  final Color color;

  const ErrorInfo({required this.mensaje, required this.color});
}
