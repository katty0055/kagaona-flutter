import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgaona/bloc/categoria_bloc.dart';
import 'package:kgaona/bloc/categoria_event.dart';
import 'package:kgaona/bloc/categoria_state.dart';
//import 'package:kgaona/components/add_button.dart';
import 'package:kgaona/components/floating_add_button.dart';
import 'package:kgaona/components/last_updated_header.dart';
import 'package:kgaona/constants/constants.dart';
import 'package:kgaona/data/categoria_repository.dart';
import 'package:kgaona/components/categoria_card.dart';
import 'package:kgaona/components/side_menu.dart';
import 'package:kgaona/components/custom_bottom_navigation_bar.dart';
import 'package:kgaona/domain/categoria.dart';
import 'package:kgaona/components/formulario_categoria.dart';
import 'package:kgaona/helpers/dialog_helper.dart';
import 'package:kgaona/helpers/error_processor_helper.dart';
import 'package:kgaona/helpers/modal_helper.dart';
import 'package:kgaona/helpers/snackbar_helper.dart';


class CategoriaScreenDos extends StatelessWidget {
  DateTime? _lastUpdated;

  @override
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CategoriaBloc()
            ..add(CategoriaInitEvent()),
        ),
      ],
      child: Builder(
        builder: (context) {
          return BlocConsumer<CategoriaBloc, CategoriaState>(
            listener: (context, state) {
              if (state is CategoriaError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Categorías de Noticias'),
                  centerTitle: true,
                  actions: [
                    // IconButton(
                    //   icon: const Icon(Icons.refresh),
                    //   onPressed: {
                    //
                    //   },
                    //),
                  ],
                ),
                drawer: const SideMenu(),
                backgroundColor: Colors.white,
                bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: 2),
                body:  Column(
                  children: [
                    LastUpdatedHeader(lastUpdated: _lastUpdated),
                    // AddButton(
                    //   text: 'Agregar Categoria',
                    //   onPressed: () => _mostrarModalAgregarCategoria(),
                    // ),
                    Expanded(
                      child: _construirCuerpoCategorias(context, state),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }


  Widget _construirCuerpoCategorias(BuildContext context, CategoriaState state) {
    if (state is CategoriaLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    else if (state is CategoriaLoaded) {
      return RefreshIndicator(
          onRefresh: () async {
            context.read<CategoriaBloc>().add(CategoriaInitEvent());
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(), // Necesario para pull-to-refresh
            itemCount: state.categorias.length,
            itemBuilder: (context, index) {
              final categoria = state.categorias[index];
              return CategoriaCard(
                categoria: categoria,
                onEdit: () => {},
                onDelete: () => {},
              );
            },
          )
      );
    } else {
      return Container();
    }
  }
}

