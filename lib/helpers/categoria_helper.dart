import 'package:flutter/material.dart';
import 'package:kgaona/api/service/categoria_service.dart';
import 'package:kgaona/components/formulario_agregar_categoria.dart';
import 'package:kgaona/domain/categoria.dart';
import 'package:kgaona/exceptions/api_exception.dart';
import 'package:kgaona/helpers/error_helper.dart';

// Función para mostrar el modal de agregar categoría
Future<void> mostrarModalAgregarCategoria({
  required BuildContext context,
  required CategoriaService categoriaService,
  required Function() onCategoriaCreada,
}) async {
  final categoria = await showModalBottomSheet<Category>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => const FormularioAgregarCategoria(),
  );

  if (categoria != null && context.mounted) {
    try {
      // Capturar el mensaje que retorna el servicio
      await categoriaService.crearCategoria(categoria);
      
      if (context.mounted) {
        // Mostrar el mensaje que retorna el servicio
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Categoría creada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        onCategoriaCreada();
      }
    } catch (e) {
      if (!context.mounted) return;
      
      String errorMessage = 'Error desconocido';
      Color errorColor = Colors.grey;

      if (e is ApiException) {
        final errorData = ErrorHelper.getErrorMessageAndColor(e.statusCode);
        errorMessage = errorData['message'];
        errorColor = errorData['color'];
      } else {
        // Si es otro tipo de excepción, usar el mensaje de la excepción
        errorMessage = e.toString().replaceAll('Exception: ', '');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: errorColor),
      );
    }
  }
}

// Función para mostrar el modal de editar categoría
Future<void> mostrarModalEditarCategoria({
  required BuildContext context,
  required CategoriaService categoriaService,
  required Category categoria,
  required Function(Category categoriaEditada) onCategoriaEditada,
}) async {
  final categoriaEditada = await showModalBottomSheet<Category>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => FormularioAgregarCategoria(categoria: categoria),
  );

  if (categoriaEditada != null && context.mounted) {
    try {
      // Capturar el mensaje que retorna el servicio
      await categoriaService.actualizarCategoria(categoria.id!, categoriaEditada);
      
      if (context.mounted) {
        // Mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Categoría actualizada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        onCategoriaEditada(categoriaEditada);
      }
    } catch (e) {
      if (!context.mounted) return;
      
      String errorMessage = 'Error desconocido';
      Color errorColor = Colors.grey;

      if (e is ApiException) {
        final errorData = ErrorHelper.getErrorMessageAndColor(e.statusCode);
        errorMessage = errorData['message'];
        errorColor = errorData['color'];
      } else {
        // Si es otro tipo de excepción, usar el mensaje de la excepción
        errorMessage = e.toString().replaceAll('Exception: ', '');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: errorColor),
      );
    }
  }
}