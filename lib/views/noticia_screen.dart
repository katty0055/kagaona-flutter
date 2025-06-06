import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgaona/bloc/categoria/categoria_bloc.dart';
import 'package:kgaona/bloc/categoria/categoria_event.dart';
import 'package:kgaona/bloc/categoria/categoria_state.dart';
import 'package:kgaona/bloc/noticia/noticia_bloc.dart';
import 'package:kgaona/bloc/noticia/noticia_event.dart';
import 'package:kgaona/bloc/noticia/noticia_state.dart';
import 'package:kgaona/components/floating_add_button.dart';
import 'package:kgaona/components/formulario_noticia.dart';
import 'package:kgaona/components/last_updated_header.dart';
import 'package:kgaona/components/noticia_card.dart';
import 'package:kgaona/components/reporte_dialog.dart';
import 'package:kgaona/components/side_menu.dart';
import 'package:kgaona/constants/constantes.dart';
import 'package:kgaona/domain/categoria.dart';
import 'package:kgaona/domain/noticia.dart';
import 'package:kgaona/helpers/categoria_helper.dart';
import 'package:kgaona/helpers/dialog_helper.dart';
import 'package:kgaona/helpers/modal_helper.dart';
import 'package:kgaona/helpers/snackbar_helper.dart';
import 'package:kgaona/helpers/snackbar_manager.dart';
import 'package:kgaona/views/categoria_screen.dart';
import 'package:kgaona/views/preferencia_screen.dart';

class NoticiaScreen extends StatelessWidget {
  const NoticiaScreen({super.key});
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!SnackBarManager().isConnectivitySnackBarShowing) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    });
    return BlocProvider<CategoriaBloc>(
      create: (context) => CategoriaBloc()..add(CategoriaInitEvent()),
      child: _NoticiaScreenContent(),
    );
  }
}

class _NoticiaScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoticiaBloc, NoticiaState>(
      listener: (context, state) {
        if (state is NoticiaError) {
          SnackBarHelper.manejarError(context, state.error);
        } else if (state is NoticiaCreated) {
          SnackBarHelper.mostrarExito(
            context,
            mensaje: NoticiasConstantes.successCreated,
          );
        } else if (state is NoticiaUpdated) {
          SnackBarHelper.mostrarExito(
            context,
            mensaje: NoticiasConstantes.successUpdated,
          );
        } else if (state is NoticiaDeleted) {
          SnackBarHelper.mostrarExito(
            context,
            mensaje: NoticiasConstantes.successDeleted,
          );
        } else if (state is NoticiaLoaded) {
          if (state.noticias.isEmpty) {
            SnackBarHelper.mostrarInfo(
              context,
              mensaje: NoticiasConstantes.listaVacia,
            );
          } else {
            SnackBarHelper.mostrarExito(
              context,
              mensaje: NoticiasConstantes.successLoaded,
            );
          }
        }
      },
      builder: (context, state) {
        DateTime? lastUpdated;
        if (state is NoticiaLoaded) {
          lastUpdated = state.lastUpdated;
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text(NoticiasConstantes.tituloApp),
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () async {
                  final noticiaBloc = context.read<NoticiaBloc>();
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => BlocProvider.value(
                            value: noticiaBloc,
                            child: const PreferenciaScreen(),
                          ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.category),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CategoriaScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          drawer: const SideMenu(),
          backgroundColor: Colors.white,
          body: Column(
            children: [
              LastUpdatedHeader(lastUpdated: lastUpdated),
              Expanded(child: _construirCuerpoNoticias(context, state)),
            ],
          ),
          floatingActionButton: BlocBuilder<CategoriaBloc, CategoriaState>(
            builder: (context, categoriaState) {
              return FloatingAddButton(
                onPressed: () async {
                  if (categoriaState is! CategoriaLoaded) {
                    context.read<CategoriaBloc>().add(CategoriaInitEvent());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cargando categorías...')),
                    );
                    return;
                  }
                  final List<Categoria> categorias = categoriaState.categorias;
                  final noticia = await ModalHelper.mostrarDialogo<Noticia>(
                    context: context,
                    title: NoticiasConstantes.addNoticia,
                    child: FormularioNoticia(categorias: categorias),
                  );
                  if (noticia != null && context.mounted) {
                    context.read<NoticiaBloc>().add(AddNoticiaEvent(noticia));
                  }
                },
              );
            },
          ),
        );
      },
    );
  }

  // Agregar este widget para mostrar el indicador de filtrado
  Widget _construirIndicadorFiltro(BuildContext context, NoticiaState state) {
    if (state is! NoticiaLoaded || !state.estaFiltrado) {
      return const SizedBox.shrink(); // No mostrar nada si no hay filtro
    }

    final theme = Theme.of(context);
    final categoriaBloc = context.watch<CategoriaBloc>();
    final categoriaState = categoriaBloc.state;
    
    // Obtener nombres de categorías filtradas
    List<String> nombresCategorias = [];
    if (categoriaState is CategoriaLoaded && state.categoriasFiltradas != null) {
      for (String categoriaId in state.categoriasFiltradas!) {
        final categoria = categoriaState.categorias
            .firstWhere(
              (cat) => cat.id == categoriaId, 
              orElse: () => Categoria(
                id: categoriaId,
                nombre: 'Desconocida',
                descripcion: '',
                imagenUrl: '',
              ),
            );
        nombresCategorias.add(categoria.nombre);
      }
    } else {
      nombresCategorias = ['categorías seleccionadas'];
    }
    
    final textoFiltro = nombresCategorias.length > 1
        ? '${nombresCategorias.length} categorías'
        : nombresCategorias.first;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: theme.colorScheme.primary.withAlpha(77),
          ),
        ),
        color: theme.colorScheme.primary.withAlpha(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(
                Icons.filter_list,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Filtrando por: $textoFiltro",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // Limpiar filtros
                  context.read<NoticiaBloc>().add(
                    FilterNoticiasByPreferenciasEvent([]),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Limpiar",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.close,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirCuerpoNoticias(BuildContext context, NoticiaState state) {
    if (state is NoticiaLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is NoticiaError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.error.message,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed:
                  () => context.read<NoticiaBloc>().add(FetchNoticiasEvent()),
              child: const Text(ValidacionConstantes.reintentar),
            ),
          ],
        ),
      );
    } else if (state is NoticiaLoaded) {
      final categoriaState = context.watch<CategoriaBloc>().state;
      List<Categoria> categorias = [];

      if (categoriaState is CategoriaLoaded) {
        categorias = categoriaState.categorias;
      }
      
      if (state.noticias.isNotEmpty) {
        return Column(
          children: [
            _construirIndicadorFiltro(context, state), // Agregar el indicador aquí
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(milliseconds: 1200));
                  if (context.mounted) {
                    context.read<NoticiaBloc>().add(FetchNoticiasEvent());
                  }
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: state.noticias.length,
                  itemBuilder: (context, index) {
                    final noticia = state.noticias[index];
                    return Dismissible(
                      key: Key(noticia.id ?? UniqueKey().toString()),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.startToEnd,
                      confirmDismiss: (direction) async {
                        return await DialogHelper.mostrarConfirmacion(
                          context: context,
                          titulo: ValidacionConstantes.confirmarEliminar,
                          mensaje: NoticiasConstantes.mensajeEliminar,
                          textoCancelar: ValidacionConstantes.cancelar,
                          textoConfirmar: ValidacionConstantes.eliminar,
                        );
                      },
                      onDismissed: (direction) {
                        context.read<NoticiaBloc>().add(
                          DeleteNoticiaEvent(noticia.id!),
                        );
                      },
                      child: NoticiaCard(
                        noticia: noticia,
                        onReport: () {
                          ReporteDialog.mostrarDialogoReporte(
                            context: context,
                            noticia: noticia,
                          );
                        },
                        onEdit: () async {
                          if (categorias.isEmpty) {
                            SnackBarHelper.mostrarInfo(
                              context,
                              mensaje: CategoriaConstantes.mensajeCargando,
                            );
                            context.read<CategoriaBloc>().add(CategoriaInitEvent());
                            return;
                          }

                          final noticiaEditada =
                              await ModalHelper.mostrarDialogo<Noticia>(
                                context: context,
                                title: NoticiasConstantes.editarNoticia,
                                child: FormularioNoticia(
                                  noticia: noticia,
                                  categorias: categorias,
                                ),
                              );

                          if (noticiaEditada != null && context.mounted) {
                            final noticiaActualizada = noticiaEditada.copyWith(
                              id: noticia.id,
                            );
                            context.read<NoticiaBloc>().add(
                              UpdateNoticiaEvent(noticiaActualizada),
                            );
                          }
                        },
                        categoriaNombre: CategoriaHelper.obtenerNombreCategoria(
                          noticia.categoriaId ?? '',
                          categorias,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      } else {
        return Column(
          children: [
            _construirIndicadorFiltro(context, state), // Agregar el indicador aquí también
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(milliseconds: 1200));
                  if (context.mounted) {
                    context.read<NoticiaBloc>().add(FetchNoticiasEvent());
                  }
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: const Center(child: Text(NoticiasConstantes.listaVacia)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }
    } else {
      return Container();
    }
  }
}
