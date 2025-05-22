import 'package:flutter/material.dart';

class ErrorHelper {
  /// Devuelve un mensaje y un color basado en el código HTTP
  static Color getErrorColor(int statusCode) {
    Color color;
    switch (statusCode) {
      case 400:
        color = Colors.red;
        break;
      case 401:
        color = Colors.orange;
        break;
      case 403:
      case 562:
        color = Colors.redAccent;
        break;
      case 404:
        color = Colors.grey;
        break;
      case 500:
        color = Colors.red;
        break;
      case 503:
        color = Colors.red;
        break;
      default:
        color = Colors.purple;
        break;
    }
    return  color;
  }
}
