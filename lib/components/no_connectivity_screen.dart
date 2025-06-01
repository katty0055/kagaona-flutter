import 'package:flutter/material.dart';
import 'package:kgaona/components/dinosaur_animation.dart';
import 'package:kgaona/components/responsive_container.dart';
import 'package:kgaona/helpers/common_widgets_helper.dart';
import 'package:kgaona/helpers/snackbar_helper.dart';

class NoConnectivityScreen extends StatelessWidget {
  const NoConnectivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: ResponsiveContainer(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CommonWidgetsHelper.paddingContainer32(
                          color: theme.colorScheme.surface,
                          child: Column(
                            children: [CommonWidgetsHelper.iconoTitulo(icon: Icons.wifi_off)],
                          ),
                        ),
                        CommonWidgetsHelper.mensaje(
                          titulo: '¡Sin conexión a Internet!',
                          mensaje:
                              'Por favor, verifica tu conexión a internet e inténtalo nuevamente.',
                        ),
                        CommonWidgetsHelper.buildSpacing16(),
                        const SizedBox(
                          height: 80,
                          width: 80,
                          child: DinosaurAnimation(),
                        ),
                        CommonWidgetsHelper.buildSpacing16(),
                        FilledButton.icon(
                          onPressed: () {
                            SnackBarHelper.mostrarInfo(
                              context,
                              mensaje: 'Verificando conexión...',
                              duracion: const Duration(seconds: 2),
                            );
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
