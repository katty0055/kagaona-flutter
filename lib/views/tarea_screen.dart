import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgaona/bloc/tarea/tarea_bloc.dart';
import 'package:kgaona/bloc/tarea/tarea_event.dart';
import 'package:kgaona/bloc/tarea/tarea_state.dart';
import 'package:kgaona/bloc/tarea_contador/tarea_contador_bloc.dart';
import 'package:kgaona/bloc/tarea_contador/tarea_contador_event.dart';
import 'package:kgaona/components/tarea_modal.dart';
import 'package:kgaona/components/last_updated_header.dart';
import 'package:kgaona/components/side_menu.dart';
import 'package:kgaona/components/tarea_progreso_indicator.dart';
import 'package:kgaona/constants/constantes.dart';
import 'package:kgaona/domain/tarea.dart';
import 'package:kgaona/helpers/dialog_helper.dart';
import 'package:kgaona/helpers/snackbar_helper.dart';
import 'package:kgaona/views/tarea_detalles_screen.dart';

class TareaScreen extends StatelessWidget {
  const TareaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TareaBloc>(
          create: (context) => TareaBloc()..add(LoadTareasEvent()),
        ),
        BlocProvider<TareaContadorBloc>(
          create: (context) => TareaContadorBloc(),
        ),
      ],
      child: const _TareaScreenContent(),
    );
  }
}

class _TareaScreenContent extends StatefulWidget {
  const _TareaScreenContent();

  @override
  _TareaScreenContentState createState() => _TareaScreenContentState();
}

class _TareaScreenContentState extends State<_TareaScreenContent> {
  static const int _limiteTareas = 3;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<TareaBloc, TareaState>(
      listener: (context, state) {
        if (state is TareaError) {
          SnackBarHelper.manejarError(context, state.error);
        } else if (state is TareaCompletada) {
          if (state.completada) {
            context.read<TareaContadorBloc>().add(IncrementarContador());
            SnackBarHelper.mostrarExito(
              context,
              mensaje: 'Tarea completada exitosamente',
            );
          } else {
            context.read<TareaContadorBloc>().add(DecrementarContador());
            SnackBarHelper.mostrarAdvertencia(
              context,
              mensaje: 'Tarea marcada como pendiente',
            );
          }
        } else if (state is TareaLoaded) {
          final totalCompletadas =
              state.tareas.where((t) => t.completado).length;
          final tareaContadorBloc = context.read<TareaContadorBloc>();
          tareaContadorBloc.add(SetTotalTareas(state.tareas.length));
          tareaContadorBloc.add(SetCompletadas(totalCompletadas));
        }
      },
      builder: (context, state) {
        DateTime? lastUpdated;
        if (state is TareaLoaded) {
          lastUpdated = state.lastUpdated;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              state is TareaLoaded
                  ? '${TareasConstantes.tituloAppBar} - Total: ${state.tareas.length}'
                  : TareasConstantes.tituloAppBar,
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Recargar tareas',
                onPressed: () {
                  context.read<TareaBloc>().add(
                    LoadTareasEvent(forzarRecarga: true),
                  );
                  SnackBarHelper.mostrarInfo(
                    context,
                    mensaje: 'Recargando tareas...',
                  );
                },
              ),
            ],
          ),
          drawer: const SideMenu(),
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Column(
            children: [
              LastUpdatedHeader(lastUpdated: lastUpdated),
              if (state is TareaLoaded) const TareaProgresoIndicator(),
              Expanded(child: _construirCuerpoTareas(context, state)),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _mostrarModalAgregarTarea(context),
            tooltip: 'Agregar Tarea',
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _construirCuerpoTareas(BuildContext context, TareaState state) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.primary,
      onRefresh: () async {
        context.read<TareaBloc>().add(LoadTareasEvent(forzarRecarga: true));
      },
      child: _construirContenidoTareas(context, state),
    );
  }

  Widget _construirContenidoTareas(BuildContext context, TareaState state) {
    final theme = Theme.of(context);

    if (state is TareaInitial || state is TareaLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text('Cargando tareas...', style: theme.textTheme.bodyMedium),
          ],
        ),
      );
    }

    if (state is TareaError && state is! TareaLoaded) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.error.message,
                  style: TextStyle(color: theme.colorScheme.error),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed:
                      () => context.read<TareaBloc>().add(LoadTareasEvent()),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (state is TareaLoaded) {
      final tareasLimitadas = state.tareas.take(_limiteTareas).toList();
      return tareasLimitadas.isEmpty
          ? ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
                  child: Text(
                    TareasConstantes.listaVacia,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          )
          : ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: state.tareas.length,
            itemBuilder: (context, index) {
              if (index == state.tareas.length) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                );
              }
              final tarea = state.tareas[index];
              return Dismissible(
                key: Key(tarea.id.toString()),
                background: Container(
                  color: theme.colorScheme.error,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(Icons.delete, color: theme.colorScheme.surface),
                ),
                direction: DismissDirection.startToEnd,
                confirmDismiss: (direction) async {
                  return await DialogHelper.mostrarConfirmacion(
                    context: context,
                    titulo: 'Confirmar eliminación',
                    mensaje: '¿Estás seguro de que deseas eliminar esta tarea?',
                    textoCancelar: 'Cancelar',
                    textoConfirmar: 'Eliminar',
                  );
                },
                onDismissed: (_) {
                  context.read<TareaBloc>().add(DeleteTareaEvent(tarea.id!));
                },
                child: GestureDetector(
                  onTap:
                      () => _mostrarDetallesTarea(context, index, state.tareas),
                  child: construirTarjetaDeportiva(tarea),
                ),
              );
            },
          );
    }
    return const SizedBox.shrink();
  }

  void _mostrarDetallesTarea(
    BuildContext context,
    int indice,
    List<Tarea> tareas,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailsScreen(tareas: tareas, indice: indice),
      ),
    );
  }

  void _mostrarModalEditarTarea(BuildContext context, Tarea tarea) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => TareaModal(
            taskToEdit: tarea,
            onTaskAdded: (Tarea tareaEditada) {
              context.read<TareaBloc>().add(UpdateTareaEvent(tareaEditada));
            },
          ),
    );
  }

  void _mostrarModalAgregarTarea(BuildContext context) {
    final state = context.read<TareaBloc>().state;
    if (state is TareaLoaded && state.tareas.length >= _limiteTareas) {
      SnackBarHelper.mostrarAdvertencia(
        context,
        mensaje:
            'Solo puedes tener $_limiteTareas tareas. Elimina una tarea existente para crear una nueva.',
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => TareaModal(
            onTaskAdded: (Tarea nuevaTarea) {
              context.read<TareaBloc>().add(CreateTareaEvent(nuevaTarea));
            },
          ),
    );
  }

  Widget construirTarjetaDeportiva(Tarea tarea) {
    final theme = Theme.of(context);
    final bool esUrgente = tarea.tipo != 'normal';
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: esUrgente ? theme.cardTheme.shape : null,
      child: Container(
        decoration:
            esUrgente
                ? BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.error.withAlpha(25),
                      theme.colorScheme.error.withAlpha(77),
                    ],
                  ),
                )
                : null,
        child: ListTile(
          contentPadding:
              theme.listTileTheme.contentPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Checkbox(
            value: tarea.completado,
            onChanged: (bool? value) {
              if (value != null) {
                context.read<TareaBloc>().add(
                  CompletarTareaEvent(tarea: tarea, completada: value),
                );
              }
            },
          ),
          title: Text(
            tarea.titulo,
            style: theme.textTheme.titleMedium?.copyWith(
              decoration: tarea.completado ? TextDecoration.lineThrough : null,
              color:
                  tarea.completado
                      ? theme.disabledColor
                      : esUrgente
                      ? theme.colorScheme.error
                      : null,
              fontWeight: esUrgente ? FontWeight.bold : null,
            ),
          ),
          subtitle:
              tarea.descripcion != null && tarea.descripcion!.isNotEmpty
                  ? Text(
                    tarea.descripcion!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: tarea.completado ? theme.disabledColor : null,
                    ),
                  )
                  : null,
          trailing: IconButton(
            icon: Icon(Icons.edit, color: theme.colorScheme.primary, size: 20),
            onPressed: () => _mostrarModalEditarTarea(context, tarea),
          ),
        ),
      ),
    );
  }
}
