import 'package:flutter/material.dart';
import 'package:kgaona/api/service/noticia_service.dart';
import 'package:kgaona/api/service/categoria_service.dart';
import 'package:kgaona/components/noticia_card.dart';
import 'package:kgaona/constants.dart';
import 'package:kgaona/domain/categoria.dart';
import 'package:kgaona/domain/noticia.dart';
import 'package:kgaona/components/formulario_agregar_noticia.dart';
import 'package:kgaona/exceptions/api_exception.dart';
import 'package:kgaona/helpers/error_helper.dart';

Future<void> mostrarModalAgregarNoticia({
  required BuildContext context,
  required NoticiaService noticiaService,
  required CategoriaService categoriaService,
  required Function() onReinciar,
}) async {
  // Cargar categorías como lo haces actualmente
  List<Category> categorias = [];
  try {
    categorias = await categoriaService.obtenerCategorias();
  } catch (e) {
    // Si falla la carga de categorías, mostramos un error pero continuamos
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudieron cargar las categorías')),
      );
    }
  }

  if (!context.mounted) return;

  final noticia = await showModalBottomSheet<Noticia>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => FormularioAgregarNoticia(categorias: categorias),
  );

  if (noticia != null) {
    try {
      final mensajeExito = await noticiaService.crearNoticia(noticia);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(mensajeExito),
            backgroundColor: Colors.green,
          ),
        );
        onReinciar();
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
        errorMessage = e.toString().replaceAll('Exception: ', '');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: errorColor),
      );
    }
  }
}

Future<void> mostrarModalEditarNoticia({
  required BuildContext context,
  required NoticiaService noticiaService,
  required CategoriaService categoriaService,
  required Noticia noticia,
  required Function(Noticia noticiaEditada) onNoticiaEditada,
}) async {
  // Cargar las categorías para la edición
  List<Category> categorias = [];
  try {
    categorias = await categoriaService.obtenerCategorias();
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudieron cargar las categorías')),
      );
    }
  }

  if (!context.mounted) return;

  final noticiaEditada = await showModalBottomSheet<Noticia>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => FormularioAgregarNoticia(
      noticia: noticia,
      categorias: categorias,
    ),
  );

  if (noticiaEditada != null) {
    try {
      final mensajeExito = await noticiaService.editarNoticia(noticia.id!, noticiaEditada);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(mensajeExito),
            backgroundColor: Colors.green,
          ),
        );
        onNoticiaEditada(noticiaEditada);
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
        errorMessage = e.toString().replaceAll('Exception: ', '');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: errorColor),
      );
    }
  }
}

Future<void> eliminarNoticia({
  required BuildContext context,
  required NoticiaService noticiaService,
  required Noticia noticia,
  required Function() onNoticiaEliminada,
}) async {
  try {
    if (noticia.id == null || noticia.id!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se puede eliminar la noticia porque no tiene ID')),
      );
      return;
    }
    
    final mensajeExito = await noticiaService.eliminarNoticia(noticia.id!);
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensajeExito)),
      );
      onNoticiaEliminada();
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}

String obtenerNombreCategoria(String categoriaId, List<Category> categorias) {
  if (categoriaId.isEmpty || categoriaId == ConstantesCategoria.defaultcategoriaId) {
    return ConstantesCategoria.defaultcategoriaId;
  }
  
  // Busca la categoría en la lista de categorías
  final categoria = categorias.firstWhere(
    (c) => c.id == categoriaId,
    orElse: () => Category(id: '', nombre: 'Desconocida', descripcion: '', imagenUrl: '')
  );
  return categoria.nombre;
}

Widget construirCuerpoNoticias({
  required bool isLoading,
  required String? errorMessage,
  required bool hasError, // Nuevo parámetro
  required List<Noticia> noticias,
  required bool hasMore,
  required ScrollController scrollController,
  required BuildContext context,
  required NoticiaService noticiaService,
  required Function(Noticia noticia, int index) onEdit,
  required Function(Noticia noticia, int index) onDelete, // Nuevo parámetro para eliminar
  required VoidCallback onRetry,
  required List<Category> categorias, // Nueva lista de categorías
  bool mostrarIndicadorCarga = true, // Nuevo parámetro para controlar el indicador
}) {
  if (isLoading && noticias.isEmpty) {
    return const Center(child: Text(ConstantesNoticias.mensajeCargando));
  } else if (hasError && noticias.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            errorMessage ?? ConstantesNoticias.mensajeError,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  } else if (noticias.isEmpty) {
    return const Center(child: Text(ConstantesNoticias.listaVacia));
  } else {
    return ListView.builder(
      controller: scrollController,
      // Si mostrarIndicadorCarga es false, no agregamos el elemento extra para el indicador
      itemCount: noticias.length + ((hasMore && mostrarIndicadorCarga) ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == noticias.length && hasMore && mostrarIndicadorCarga) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        }
        final noticia = noticias[index];
       // Envolver el NoticiaCard con un Dismissible
        return Dismissible(
          key: Key(noticia.id ?? UniqueKey().toString()),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            // Mostrar un diálogo de confirmación
            return await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirmar eliminación'),
                  content: const Text('¿Estás seguro de que deseas eliminar esta noticia?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Eliminar'),
                    ),
                  ],
                );
              },
            );
          },
          onDismissed: (direction) {
            onDelete(noticia, index);
          },
          child: NoticiaCard(
            noticia: noticia,
            onEdit: () => onEdit(noticia, index),
            categoriaNombre: obtenerNombreCategoria(noticia.categoriaId, categorias),
          ),
        );
      },
    );
  }
}