import 'package:flutter/material.dart';
import 'package:kgaona/api/service/noticia_service.dart';
import 'package:kgaona/components/noticia_card.dart';
import 'package:kgaona/constants.dart';
import 'package:kgaona/domain/noticia.dart';
import 'package:kgaona/components/formulario_agregar_noticia.dart';

Future<void> mostrarModalAgregarNoticia({
  required BuildContext context,
  required NoticiaService noticiaService,
   required Function() onReinciar, // Nuevo callback para cargar la última página
}) async {
  final noticia = await showModalBottomSheet<Noticia>(
    context: context,
    isScrollControlled: true,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: const FormularioAgregarNoticia(),
    ),
  );

  if (noticia != null) {
    try {
      final mensajeExito = await noticiaService.crearNoticia(noticia);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mensajeExito)),
        );

        // En lugar de recargar desde la primera página, cargamos la última página
        onReinciar();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }
}

Future<void> mostrarModalEditarNoticia({
  required BuildContext context,
  required NoticiaService noticiaService,
  required Noticia noticia,
  required Function(Noticia noticiaEditada) onNoticiaEditada,
}) async {
  final noticiaEditada = await showModalBottomSheet<Noticia>(
    context: context,
    isScrollControlled: true,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: FormularioAgregarNoticia(noticia: noticia),
    ),
  );

  if (noticiaEditada != null) {
    try {
      final mensajeExito = await noticiaService.editarNoticia(noticia.id!, noticiaEditada);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mensajeExito)),
        );
        onNoticiaEditada(noticiaEditada);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
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
          ),
        );
      },
    );
  }
}