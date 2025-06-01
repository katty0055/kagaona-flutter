import 'package:flutter/material.dart';

class ModalHelper {
  /// Muestra un diálogo directamente sin envolverlo en AlertDialog adicional
  static Future<T?> mostrarDialogo<T>({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = true,
    String? title,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) => child,
    );
  }
}