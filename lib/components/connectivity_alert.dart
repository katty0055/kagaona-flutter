import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgaona/bloc/connectivity/connectivity_bloc.dart';
import 'package:kgaona/bloc/connectivity/connectivity_state.dart';
import 'package:kgaona/exceptions/api_exception.dart';
import 'package:kgaona/helpers/snackbar_helper.dart';

/// Widget que muestra una alerta cuando no hay conectividad a Internet usando SnackBar
class ConnectivityAlert extends StatelessWidget {
  const ConnectivityAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityBloc, ConnectivityState>(
      listenWhen: (previous, current) {
        // Solo actuar cuando hay un cambio real en el estado de conectividad
        return (previous is ConnectivityConnected && current is ConnectivityDisconnected) || 
               (previous is ConnectivityDisconnected && current is ConnectivityConnected);
      },
      listener: (context, state) {
        if (state is ConnectivityDisconnected) {
          // Mostrar mensaje de error de conectividad utilizando SnackBarHelper
          SnackBarHelper.manejarError(
            context,
            ApiException(
              'Por favor, verifica tu conexión a internet.',
              statusCode: 503,
            ),
             duration: const Duration(days: 1),
          );
        } else if (state is ConnectivityConnected) {
          // Ocultar SnackBar cuando se recupera la conexión
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }
      },
      child: const SizedBox.shrink(), // Widget invisible
    );
  }
}
