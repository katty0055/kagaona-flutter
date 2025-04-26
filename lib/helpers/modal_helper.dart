import 'package:flutter/material.dart';

class ModalHelper {
  static Future<T?> mostrarModal<T>({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = true,
    BorderRadius? borderRadius,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      shape: borderRadius != null 
          ? RoundedRectangleBorder(borderRadius: borderRadius) 
          : null,
      builder: (context) => child,
    );
  }
}