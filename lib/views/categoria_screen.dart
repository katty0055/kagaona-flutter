import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgaona/bloc/categoria/categoria_bloc.dart';
import 'package:kgaona/bloc/categoria/categoria_event.dart';
import 'package:kgaona/bloc/categoria/categoria_state.dart';
import 'package:kgaona/components/floating_add_button.dart';
import 'package:kgaona/components/last_updated_header.dart';
import 'package:kgaona/constants/constants.dart';
import 'package:kgaona/components/categoria_card.dart';
import 'package:kgaona/components/side_menu.dart';
import 'package:kgaona/components/custom_bottom_navigation_bar.dart';
import 'package:kgaona/components/formulario_categoria.dart';
import 'package:kgaona/domain/categoria.dart';
import 'package:kgaona/helpers/dialog_helper.dart';
import 'package:kgaona/helpers/error_processor_helper.dart';
import 'package:kgaona/helpers/modal_helper.dart';
import 'package:kgaona/helpers/snackbar_helper.dart';

class CategoriaScreen extends StatelessWidget {
  const CategoriaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Limpiar cualquier SnackBar existente al entrar a esta pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    });
    return BlocProvider(
      create: (context) => CategoriaBloc()..add(CategoriaInitEvent()),
      child: _CategoriaScreenContent(),
    );
  }
}

class _CategoriaScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoriaBloc, CategoriaState>(
      listener: (context, state) {
        if (state is CategoriaError) {
          // Determinar el tipo de error según el mensaje
          final mensajeError = switch (state.tipoOperacion) {
            TipoOperacion.actualizar => 'Error al actualizar la categoría',
            TipoOperacion.crear => 'Error al crear la categoría',
            TipoOperacion.eliminar => 'Error al eliminar la categoría',
            _ => 'Error al cargar las categorías'
          };

          ErrorProcessorHelper.manejarError(
            context,
            state.error,
            mensajePredeterminado: mensajeError,
          );
        } else if (state is CategoriaCreated) {
          // Mensaje específico para creación
          SnackBarHelper.mostrarExito(
            context,
            mensaje: ConstantesCategoria.successCreated,
          );
        } else if (state is CategoriaUpdated) {
          // Mensaje específico para actualización
          SnackBarHelper.mostrarExito(
            context,
            mensaje: ConstantesCategoria.successUpdated,
          );
        }else if (state is CategoriaDeleted) {
          SnackBarHelper.mostrarExito(
            context,
            mensaje: ConstantesCategoria.successDeleted,
          );
        } else if (state is CategoriaLoaded) {
          if (state.categorias.isEmpty) {
            SnackBarHelper.mostrarInfo(
              context,
              mensaje: ConstantesCategoria.listaVacia,
            );
          }else{
            SnackBarHelper.mostrarExito(
              context,
              mensaje: 'Categorías cargadas correctamente',
            );
          }
        }
      },
      builder: (context, state) {
        DateTime? lastUpdated;
        if (state is CategoriaLoaded) {
          lastUpdated = state.lastUpdated;
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Categorías de Noticias'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed:
                    () =>
                        context.read<CategoriaBloc>().add(CategoriaInitEvent()),
              ),
            ],
          ),
          drawer: const SideMenu(),
          backgroundColor: Colors.white,
          floatingActionButton: FloatingAddButton(
            onPressed: () async {
              final categoria = await ModalHelper.mostrarDialogo<Categoria>(
                context: context,
                title: 'Agregar Categoría',
                child: const FormularioCategoria(),
              );

              // Si se obtuvo una categoría del formulario y el contexto sigue montado
              if (categoria != null && context.mounted) {
                // Usar el BLoC para crear la categoría
                context.read<CategoriaBloc>().add(
                  CategoriaCreateEvent(categoria),
                );
              }
            },
            tooltip: 'Agregar Categoría',
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          bottomNavigationBar: const CustomBottomNavigationBar(
            selectedIndex: 2,
          ),
          body: Column(
            children: [
              LastUpdatedHeader(lastUpdated: lastUpdated),
              Expanded(child: _construirCuerpoCategorias(context, state)),
            ],
          ),
        );
      },
    );
  }

  Widget _construirCuerpoCategorias(
    BuildContext context,
    CategoriaState state,
  ) {
    if (state is CategoriaLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is CategoriaError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.message,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<CategoriaBloc>().add(CategoriaInitEvent()),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    } else if (state is CategoriaLoaded) {
      if (state.categorias.isNotEmpty) {
        return RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 1200));
            if (context.mounted) {
              context.read<CategoriaBloc>().add(CategoriaInitEvent());
            }
          },
          child: ListView.builder(
            physics:
                const AlwaysScrollableScrollPhysics(), // Necesario para pull-to-refresh
            itemCount: state.categorias.length,
            itemBuilder: (context, index) {
              final categoria = state.categorias[index];
              return CategoriaCard(
                categoria: categoria,
                onEdit: () async {
                  final categoriaEditada = await ModalHelper.mostrarDialogo<Categoria>(
                    context: context,
                    title: 'Editar Categoría',
                    child: FormularioCategoria(categoria: categoria),
                  );

                  if (categoriaEditada != null && context.mounted) {
                    // Usar el BLoC para actualizar la categoría
                    context.read<CategoriaBloc>().add(
                      CategoriaUpdateEvent(categoria.id!, categoriaEditada),
                    );
                  }
                },
                onDelete: () async {
                  // Mostrar diálogo de confirmación
                  final confirmar = await DialogHelper.mostrarConfirmacion(
                    context: context,
                    titulo: 'Confirmar eliminación',
                    mensaje: '¿Estás seguro de eliminar la categoría "${categoria.nombre}"?',
                    textoCancelar: 'Cancelar',
                    textoConfirmar: 'Eliminar',
                  );

                  if (confirmar == true && context.mounted) {
                    context.read<CategoriaBloc>().add(CategoriaDeleteEvent(categoria.id!));
                  }
                },
              );
            },
          ),
        );
      } else {
        // Añadir esta parte para manejar el caso de lista vacía
        return RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 1200));
            if (context.mounted) {
              context.read<CategoriaBloc>().add(CategoriaInitEvent());
            }            
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: const Center(child: Text(ConstantesCategoria.listaVacia)),
              ),
            ],
          ),
        );
      }
    } else {
      return Container();
    }
  }
}
