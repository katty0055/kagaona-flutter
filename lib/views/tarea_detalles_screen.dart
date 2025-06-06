import 'package:flutter/material.dart';
import 'package:kgaona/components/tarea_card.dart';
import 'package:kgaona/constants/constantes.dart';
import 'package:kgaona/domain/tarea.dart';
import 'package:kgaona/helpers/snackbar_helper.dart';

class TareaDetallesScreen extends StatelessWidget {
  final List<Tarea> tareas;
  final int indice;

  const TareaDetallesScreen({super.key, required this.tareas, required this.indice});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    });

    final theme = Theme.of(context);
    final Tarea tarea = tareas[indice];
    final String imageUrl = 'https://picsum.photos/seed/${tarea.id}/${1080}/${720}?quality=100';
    final String fechaLimiteDato = tarea.fechaLimite != null
        ? '${tarea.fechaLimite!.day}/${tarea.fechaLimite!.month}/${tarea.fechaLimite!.year}'
        : TareasConstantes.fechaLimite;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null) {
            if (details.primaryVelocity! > 0) {
              if (indice > 0) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TareaDetallesScreen(
                      tareas: tareas,
                      indice: indice - 1,
                    ),
                  ),
                );
              } else {
                SnackBarHelper.mostrarInfo(
                  context, 
                  mensaje: TareasConstantes.noHayTareasAnteriores,
                );
              }
            } else if (details.primaryVelocity! < 0) {
              if (indice < tareas.length - 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TareaDetallesScreen(
                      tareas: tareas,
                      indice: indice + 1,
                    ),
                  ),
                );
              } else {
                SnackBarHelper.mostrarInfo(
                  context,
                  mensaje: TareasConstantes.noHayTareasPosteriores,
                );
              }
            }
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Center(
              child: TaskCard(
                tarea: tarea,
                imageUrl: imageUrl,
                fechaLimiteDato: fechaLimiteDato,
                onBackPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}