import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgaona/bloc/auth/auth_bloc.dart';
import 'package:kgaona/bloc/auth/auth_event.dart';
import 'package:kgaona/bloc/noticia/noticia_bloc.dart';
import 'package:kgaona/bloc/noticia/noticia_event.dart';
import 'package:kgaona/data/preferencia_repository.dart';
import 'package:kgaona/theme/theme.dart';
import 'package:kgaona/views/login_screen.dart';
import 'package:get_it/get_it.dart';

class DialogHelper {
  /// Muestra un diálogo de confirmación genérico
  static Future<bool?> mostrarConfirmacion({
    required BuildContext context,
    required String titulo,
    required String mensaje,
    String textoCancelar = 'Cancelar',
    String textoConfirmar = 'Confirmar',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensaje),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: AppTheme.modalSecondaryButtonStyle(),
              child: Text(textoCancelar),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: AppTheme.modalActionButtonStyle(),
              child: Text(textoConfirmar),
            ),
          ],
        );
      },
    );
  }

  /// Muestra un diálogo específico para cerrar sesión
  static void mostrarDialogoCerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: AppTheme.modalSecondaryButtonStyle(), 
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final preferenciasRepo = GetIt.instance<PreferenciaRepository>();
                preferenciasRepo.invalidarCache();
                if (context.mounted) {
                  try {
                    final noticiaBloc =
                        BlocProvider.of<NoticiaBloc>(context, listen: false);
                    noticiaBloc.add(ResetNoticiaEvent());
                  } catch (e) {
                    // Ignorar si NoticiaBloc no está disponible
                  }
                }
                if (context.mounted) {
                  BlocProvider.of<AuthBloc>(context).add(AuthLogoutRequested());
                }
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false, 
                  );
                }
              },
              style: AppTheme.modalActionButtonStyle(), 
              child: const Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );
  }
}