import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgaona/bloc/noticia/noticia_bloc.dart';
import 'package:kgaona/bloc/noticia/noticia_event.dart';
import 'package:kgaona/bloc/reporte/reporte_bloc.dart';
import 'package:kgaona/bloc/reporte/reporte_event.dart';
import 'package:kgaona/bloc/reporte/reporte_state.dart';
import 'package:kgaona/domain/reporte.dart';
import 'package:kgaona/domain/noticia.dart';
import 'package:kgaona/helpers/snackbar_helper.dart';
import 'package:kgaona/theme/theme.dart';
import 'package:watch_it/watch_it.dart';

/// Clase para mostrar el diálogo de reportes de noticias
class ReporteDialog {
  /// Muestra un diálogo de reporte para una noticia
  static Future<void> mostrarDialogoReporte({
    required BuildContext context,
    required Noticia noticia,
  }) async {
    return showDialog(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (context) => di<ReporteBloc>(),
          child: _ReporteDialogContent(
            noticiaId: noticia.id!,
            noticia: noticia,
          ),
        );
      },
    );
  }
}

class _ReporteDialogContent extends StatefulWidget {
  final String noticiaId;
  final Noticia noticia;


  const _ReporteDialogContent({required this.noticiaId, required this.noticia});

  @override
  State<_ReporteDialogContent> createState() => _ReporteDialogContentState();
}

class _ReporteDialogContentState extends State<_ReporteDialogContent> {
  bool get noticiaYaReportada => (widget.noticia.contadorReportes ?? 0) > 2;

  @override
  void initState() {
    super.initState();
    // Cargar estadísticas al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReporteBloc>().add(
        CargarEstadisticasReporte(noticia: widget.noticia),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, int> estadisticas = {
      'NoticiaInapropiada': 0,
      'InformacionFalsa': 0,
      'Otro': 0,
    };
    
    final theme = Theme.of(context);
    
    return BlocConsumer<ReporteBloc, ReporteState>(
      listener: (context, state) {
        if (state is ReporteLoading && state.motivoActual == null) {
          // Mostrar diálogo de carga
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        } else if (state is ReporteSuccess) {
          // Mostrar mensaje de éxito
          SnackBarHelper.mostrarExito(context, mensaje: state.mensaje);

          // cerramos el diálogo después de un tiempo
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        } else if (state is ReporteError) {
          // Mostrar mensaje de error
          SnackBarHelper.mostrarError(context, mensaje: state.error.message);
        } else if (state is NoticiaReportesActualizada &&
            state.noticia.id == widget.noticiaId) {
          // Actualizar directamente el contador en NoticiaBloc sin hacer petición GET
          context.read<NoticiaBloc>().add(
            ActualizarContadorReportesEvent(
              state.noticia.id!,
              state.contadorReportes,
            ),
          );
        } else if (state is ReporteEstadisticasLoaded) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        }
      },      builder: (context, state) {
        // Verificar si estamos en estado de carga y obtener el motivo actual
        final bool isLoading = state is ReporteLoading;
        final motivoActual = isLoading ? (state).motivoActual : null;
        
        if (state is ReporteEstadisticasLoaded && state.noticia.id == widget.noticiaId) {
          estadisticas = {
            'NoticiaInapropiada': state.estadisticas[MotivoReporte.noticiaInapropiada] ?? 0,
            'InformacionFalsa': state.estadisticas[MotivoReporte.informacionFalsa] ?? 0,
            'Otro': state.estadisticas[MotivoReporte.otro] ?? 0,
          };
        }
        
        return Dialog(
          shape: theme.dialogTheme.shape,
          elevation: theme.dialogTheme.elevation ?? 8.0,
          backgroundColor: theme.dialogTheme.backgroundColor,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 70.0,
            vertical: 24.0,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.error.withAlpha(20),
                  theme.colorScheme.error.withAlpha(50),
                ],
              ),
            ),
            padding: AppTheme.cardContentPadding(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  noticiaYaReportada ? 'Noticia Reportada' : 'Reportar Noticia',
                  style: theme.dialogTheme.titleTextStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  noticiaYaReportada
                    ? 'Esta noticia ya ha sido reportada'
                    : 'Selecciona el motivo:',
                  textAlign: TextAlign.center,
                  style: theme.dialogTheme.contentTextStyle,
                ),
                const SizedBox(height: 16),
                
                // Si la noticia ya fue reportada, mostrar un mensaje en lugar de los botones
                if (noticiaYaReportada)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: theme.colorScheme.primary,
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Gracias por tu interés en reportar contenido. Esta noticia ya ha sido marcada para revisión.',
                          textAlign: TextAlign.center,
                          style: theme.dialogTheme.contentTextStyle,
                        ),
                      ],
                    ),
                  )
                else
                  // Opciones de reporte con íconos y contadores adaptados al tema
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMotivoButton(
                        context: context,
                        motivo: MotivoReporte.noticiaInapropiada,
                        icon: Icons.warning,
                        color: theme.colorScheme.error,
                        label: 'Inapropiada',
                        iconNumber: '${estadisticas['NoticiaInapropiada']}',
                        isLoading: isLoading && motivoActual == MotivoReporte.noticiaInapropiada,
                        smallSize: true,
                        disabled: noticiaYaReportada,
                      ),
                      _buildMotivoButton(
                        context: context,
                        motivo: MotivoReporte.informacionFalsa,
                        icon: Icons.info,
                        color: theme.colorScheme.onError, // Color de warning definido en AppTheme
                        label: 'Falsa',
                        iconNumber: '${estadisticas['InformacionFalsa']}',
                        isLoading: isLoading && motivoActual == MotivoReporte.informacionFalsa,
                        smallSize: true,
                        disabled: noticiaYaReportada,
                      ),
                      _buildMotivoButton(
                        context: context,
                        motivo: MotivoReporte.otro,
                        icon: Icons.flag,
                        color: theme.colorScheme.secondary,
                        label: 'Otro',
                        iconNumber: '${estadisticas['Otro']}',
                        isLoading: isLoading && motivoActual == MotivoReporte.otro,
                        smallSize: true,
                        disabled: noticiaYaReportada,
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                    style: AppTheme.modalSecondaryButtonStyle(),
                    child: Text(
                      'Cerrar',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: isLoading ? theme.disabledColor : theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMotivoButton({
    required BuildContext context,
    required MotivoReporte motivo,
    required IconData icon,
    required Color color,
    required String label,
    required String iconNumber,
    bool isLoading = false,
    bool smallSize = false,
    bool disabled = false,
  }) {
    final theme = Theme.of(context);
    // Definir tamaños según el parámetro smallSize
    final buttonSize = smallSize ? 50.0 : 60.0;
    final iconSize = smallSize ? 24.0 : 30.0;
    final badgeSize = smallSize ? 16.0 : 18.0;
    final fontSize = smallSize ? 10.0 : 12.0;

    // Si está deshabilitado, aplicar un color grisáceo
    final buttonColor = disabled ? theme.disabledColor.withAlpha(51) : Colors.white;
    final iconColor = disabled ? theme.disabledColor : color;
    final badgeColor = disabled ? theme.disabledColor : color;

    return Column(
      children: [
        InkWell(
          onTap: (isLoading || disabled) ? null : () => _enviarReporte(context, motivo),
          borderRadius: BorderRadius.circular(buttonSize / 2),
          child: Container(
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              color: buttonColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: disabled ? theme.disabledColor.withAlpha(77) : theme.colorScheme.surface,
              ),
              // Sutiles sombras para profundidad
              boxShadow: disabled ? [] : [
                BoxShadow(
                  color: Colors.black.withAlpha(26),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Mostrar un indicador de carga si este botón está en proceso
                if (isLoading)
                  SizedBox(
                    width: iconSize,
                    height: iconSize,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  )
                else
                  Icon(icon, color: iconColor, size: iconSize),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: badgeSize,
                    height: badgeSize,
                    decoration: BoxDecoration(
                      color: badgeColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        isLoading ? (int.parse(iconNumber) + 1).toString() : iconNumber,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: smallSize ? 6.0 : 8.0),
        Text(
          label, 
          style: (smallSize ? theme.textTheme.bodySmall : theme.textTheme.bodyMedium)?.copyWith(
            color: disabled ? theme.disabledColor : theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
  void _enviarReporte(BuildContext context, MotivoReporte motivo) {
    // Enviar el reporte usando el bloc directamente
    context.read<ReporteBloc>().add(
      EnviarReporte(noticia: widget.noticia, motivo: motivo),
    );
  }
}
