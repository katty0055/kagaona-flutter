import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgaona/bloc/tarea_contador/tarea_contador_bloc.dart' as tarea_bloc;
import 'package:kgaona/bloc/tarea_contador/tarea_contador_state.dart';
import 'package:kgaona/helpers/common_widgets_helper.dart';
import 'package:kgaona/theme/colors.dart';
import 'package:kgaona/theme/theme.dart';

class TareaProgresoIndicator extends StatelessWidget {
  const TareaProgresoIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<tarea_bloc.TareaContadorBloc, TareaContadorState>(
      buildWhen: (previous, current) => 
        previous.completadas != current.completadas || 
        previous.total != current.total,
      builder: (context, state) {
        final theme = Theme.of(context);
        final esCompleto = state.total > 0 && state.completadas == state.total;
        final colorProgreso = esCompleto ? AppColors.success : theme.colorScheme.secondary;
        
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progreso',
                    style: theme.textTheme.headlineSmall
                  ),
                  Text(
                    '${state.completadas}/${state.total}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: esCompleto ? AppColors.success : theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              CommonWidgetsHelper.buildSpacing16(),
              // Contenedor con borde alrededor del LinearProgressIndicator
              Container(
                decoration: AppTheme.progressBarDecoration(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7), // Ligeramente menor para que el borde se vea
                  child: LinearProgressIndicator(
                    value: state.progreso,
                    minHeight: 16.0,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(colorProgreso),
                  ),
                ),
              ),
              CommonWidgetsHelper.buildSpacing16(),
              Text(
                esCompleto ? 'Todas las tareas completadas' : 'Tareas completadas',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: esCompleto ? AppColors.success : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}