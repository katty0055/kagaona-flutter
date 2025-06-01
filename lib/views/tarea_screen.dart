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
  final ScrollController _scrollController = ScrollController();
  static const int _limitePorPagina = 5;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<TareaBloc>().state;
      if (state is TareaLoaded && state.hayMasTareas) {
        context.read<TareaBloc>().add(
          LoadMoreTareasEvent(
            pagina: state.paginaActual + 1,
            limite: _limitePorPagina,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BlocConsumer<TareaBloc, TareaState>(
      listener: (context, state) {
        // Listener sin cambios
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
          final totalCompletadas = state.tareas.where((t) => t.completado).length;
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

                  // Usar SnackBarHelper consistente con el tema
                  SnackBarHelper.mostrarInfo(
                    context, 
                    mensaje: 'Recargando tareas...',
                  );
                },
              ),
            ],
          ),
          drawer: const SideMenu(),
          // Usar el color de fondo definido en el tema
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
      color: Theme.of(context).colorScheme.primary, // Color primario para el indicador
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
            CircularProgressIndicator(
              color: theme.colorScheme.primary, // Usar color primario
            ),
            const SizedBox(height: 16),
            Text(
              'Cargando tareas...',
              style: theme.textTheme.bodyMedium, // Usar estilo de texto del tema
            ),
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
                  style: TextStyle(color: theme.colorScheme.error), // Usar color de error del tema
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton( // Usar FilledButton para consistencia
                  onPressed: () => context.read<TareaBloc>().add(LoadTareasEvent()),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (state is TareaLoaded) {
      return state.tareas.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Center(
                    child: Text(
                      TareasConstantes.listaVacia,
                      style: theme.textTheme.bodyMedium, // Usar estilo de texto del tema
                    ),
                  ),
                ),
              ],
            )
          : ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: state.tareas.length + (state.hayMasTareas ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.tareas.length) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(
                        color: theme.colorScheme.primary, // Usar color primario
                      ),
                    ),
                  );
                }

                final tarea = state.tareas[index];
                return Dismissible(
                  key: Key(tarea.id.toString()),
                  background: Container(
                    color: theme.colorScheme.error, // Usar color de error del tema
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Icon(Icons.delete, color: theme.colorScheme.onError), // Usar color de texto sobre error
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
                    onTap: () => _mostrarDetallesTarea(context, index, state.tareas),
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
      builder: (dialogContext) => TareaModal(
        taskToEdit: tarea,
        onTaskAdded: (Tarea tareaEditada) {
          context.read<TareaBloc>().add(UpdateTareaEvent(tareaEditada));
        },
      ),
    );
  }

  void _mostrarModalAgregarTarea(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => TareaModal(
        onTaskAdded: (Tarea nuevaTarea) {
          context.read<TareaBloc>().add(CreateTareaEvent(nuevaTarea));
        },
      ),
    );
  }

  // Método simplificado para construir la tarjeta
  Widget construirTarjetaDeportiva(Tarea tarea) {
    final theme = Theme.of(context);
    final bool esUrgente = tarea.tipo != 'normal';
    
    // Usar card de tema con modificadores
    return Card(
      // Mantener margin consistente
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      
      // No establecer color aquí para usar el del tema
      
      // Usar el shape del tema pero con un borde más destacado para urgentes
      shape: esUrgente ? theme.cardTheme.shape : null,
      
      child: Container(
        // Para tareas urgentes, agregar gradiente
        decoration: esUrgente 
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(10), // Consistente con tema
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
          // Usar contentPadding definido en ListTileTheme
          contentPadding: theme.listTileTheme.contentPadding ?? 
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          
          // Checkbox con tema aplicado automáticamente
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
          
          // Texto con estilo del tema
          title: Text(
            tarea.titulo,
            style: theme.textTheme.titleMedium?.copyWith(
              decoration: tarea.completado ? TextDecoration.lineThrough : null,
              color: tarea.completado 
                  ? theme.disabledColor
                  : esUrgente ? theme.colorScheme.error : null, // null usa el color del tema
              fontWeight: esUrgente ? FontWeight.bold : null,
            ),
          ),
          
          // Descripción con estilo del tema
          subtitle: tarea.descripcion != null && tarea.descripcion!.isNotEmpty
            ? Text(
                tarea.descripcion!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: tarea.completado
                      ? theme.disabledColor
                      : null, // null usa el color del tema
                ),
              )
            : null,
            
          // Icono de edición usando colores del tema
          trailing: IconButton(
            icon: Icon(
              Icons.edit,
              color: theme.colorScheme.primary,
              size: 20,
            ),
            onPressed: () => _mostrarModalEditarTarea(context, tarea),
          ),
        ),
      ),
    );
  }
}
