import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgaona/bloc/tarea_contador/tarea_contador_bloc.dart' as tarea_bloc;
import 'package:kgaona/bloc/tarea_contador/tarea_contador_state.dart';

class TareaProgresoIndicator extends StatelessWidget {
  const TareaProgresoIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<tarea_bloc.TareaContadorBloc, TareaContadorState>(
      buildWhen: (previous, current) => 
        previous.completadas != current.completadas || 
        previous.total != current.total,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                '${state.completadas}/${state.total} tareas completadas',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: state.progreso,
                minHeight: 10,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ],
          ),
        );
      },
    );
  }
}