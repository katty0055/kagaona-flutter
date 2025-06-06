import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgaona/bloc/categoria/categoria_bloc.dart';
import 'package:kgaona/bloc/categoria/categoria_event.dart';
import 'package:kgaona/bloc/categoria/categoria_state.dart';
import 'package:kgaona/bloc/noticia/noticia_bloc.dart';
import 'package:kgaona/bloc/noticia/noticia_event.dart';
import 'package:kgaona/bloc/preferencia/preferencia_bloc.dart';
import 'package:kgaona/bloc/preferencia/preferencia_event.dart';
import 'package:kgaona/bloc/preferencia/preferencia_state.dart';
import 'package:kgaona/constants/constantes.dart';
import 'package:kgaona/domain/categoria.dart';
import 'package:kgaona/helpers/common_widgets_helper.dart';
import 'package:kgaona/helpers/snackbar_helper.dart';
import 'package:kgaona/helpers/snackbar_manager.dart';
import 'package:kgaona/theme/theme.dart';

class PreferenciaScreen extends StatelessWidget {
  const PreferenciaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!SnackBarManager().isConnectivitySnackBarShowing) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    });

    final noticiaBloc = BlocProvider.of<NoticiaBloc>(context, listen: false);

    return MultiBlocProvider(
      providers: [
        BlocProvider<PreferenciaBloc>(
          create: (context) => PreferenciaBloc()..add(LoadPreferences()),
        ),
        BlocProvider<CategoriaBloc>(
          create: (context) => CategoriaBloc()..add(CategoriaInitEvent()),
        ),
      ],
      child: BlocConsumer<PreferenciaBloc, PreferenciaState>(
        listener: (context, state) {
          if (state is PreferenciaError) {
            SnackBarHelper.manejarError(context, state.error);
          } else if (state is PreferenciasSaved) {
            noticiaBloc.add(
              FilterNoticiasByPreferenciasEvent(state.categoriasSeleccionadas),
            );
            SnackBarHelper.mostrarExito(
              context,
              mensaje: PreferenciaConstantes.preferenciasSaved,
            );
            Future.delayed(const Duration(milliseconds: 1250), () {
              if (context.mounted) {
                Navigator.pop(context, state.categoriasSeleccionadas);
              }
            });
          }
        },
        builder: (context, prefState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(PreferenciaConstantes.titleApp),
              elevation: 0,
            ),
            backgroundColor: theme.scaffoldBackgroundColor,
            body: Column(
              children: [
                _construirBarraSuperior(context, prefState),
                const Divider(height: 1),
                Expanded(
                  child: _construirCuerpoPreferencias(context, prefState),
                ),
                CommonWidgetsHelper.buildSpacing16(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _construirCuerpoPreferencias(
    BuildContext context,
    PreferenciaState prefState,
  ) {
    return BlocBuilder<CategoriaBloc, CategoriaState>(
      builder: (context, catState) {
        if (catState is CategoriaLoading ||
            prefState is PreferenciaLoading ||
            prefState is PreferenciasSaved) {
          return const Center(child: CircularProgressIndicator());
        } else if (catState is CategoriaError) {
          return _construirWidgetError(
            context,
            catState.error.message,
            () => context.read<CategoriaBloc>().add(CategoriaInitEvent()),
          );
        } else if (prefState is PreferenciaError) {
          return _construirWidgetError(
            context,
            prefState.error.message,
            () => context.read<PreferenciaBloc>().add(LoadPreferences()),
          );
        } else if (catState is CategoriaLoaded) {
          final categorias = catState.categorias;
          return _construirListaCategorias(context, prefState, categorias);
        }
        return const Center(child: Text(AppConstantes.errorDesconocido));
      },
    );
  }

  Widget _construirListaCategorias(
    BuildContext context,
    PreferenciaState state,
    List<Categoria> categorias,
  ) {
    final theme = Theme.of(context);

    if (categorias.isEmpty) {
      return Center(
        child: CommonWidgetsHelper.mensaje(
          titulo: CategoriaConstantes.defaultcategoriaId,
          mensaje: PreferenciaConstantes.noCategoria,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        final categoria = categorias[index];
        return BlocBuilder<PreferenciaBloc, PreferenciaState>(
          buildWhen: (previous, current) {
            if (previous is PreferenciasLoaded &&
                current is PreferenciasLoaded) {
              return previous.categoriasSeleccionadas.contains(categoria.id) !=
                  current.categoriasSeleccionadas.contains(categoria.id);
            }
            return true;
          },
          builder: (context, state) {
            final isSelected =
                state is PreferenciasLoaded &&
                state.categoriasSeleccionadas.contains(categoria.id);

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: CheckboxListTile(
                value: isSelected,
                onChanged:
                    (_) => _toggleCategoria(context, categoria.id!, isSelected),
                title: Text(
                  categoria.nombre,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : null,
                    color: isSelected ? theme.colorScheme.primary : null,
                  ),
                ),
                activeColor: theme.colorScheme.primary,
                checkboxShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _construirBarraSuperior(BuildContext context, PreferenciaState state) {
    return BlocBuilder<PreferenciaBloc, PreferenciaState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        final isEnabled =
            state is! PreferenciaError && state is! PreferenciaLoading;
        final numCategorias =
            state is PreferenciasLoaded
                ? state.categoriasSeleccionadas.length
                : 0;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(color: theme.cardColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    ValidacionConstantes.seleccionadas,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(178),
                    ),
                  ),
                  Text(
                    numCategorias.toString(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed:
                        () =>
                            context.read<PreferenciaBloc>().add(ResetFilters()),
                    style: AppTheme.modalSecondaryButtonStyle(),
                    child: const Text(ValidacionConstantes.limpiar),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed:
                        isEnabled
                            ? () => _aplicarFiltros(context, state)
                            : null,
                    style: AppTheme.modalActionButtonStyle(),
                    child: const Text(ValidacionConstantes.aplicar),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _construirWidgetError(
    BuildContext context,
    String message,
    VoidCallback onRetry,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text(ValidacionConstantes.reintentar),
          ),
        ],
      ),
    );
  }

  void _toggleCategoria(
    BuildContext context,
    String categoriaId,
    bool isSelected,
  ) {
    final currentState = context.read<PreferenciaBloc>().state;
    if (currentState is PreferenciasLoaded) {
      context.read<PreferenciaBloc>().add(
        ChangeCategory(categoriaId, !isSelected),
      );
    }
  }

  void _aplicarFiltros(BuildContext context, PreferenciaState state) {
    if (state is PreferenciaError) {
      SnackBarHelper.mostrarAdvertencia(
        context,
        mensaje: PreferenciaConstantes.errorNoFiltro,
      );
      return;
    }

    if (state is PreferenciasLoaded) {
      context.read<PreferenciaBloc>().add(
        SavePreferences(state.categoriasSeleccionadas),
      );
    } else {
      SnackBarHelper.mostrarAdvertencia(
        context,
        mensaje: PreferenciaConstantes.preferenciaInvalida,
      );
    }
  }
}
