import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgaona/bloc/categoria/categoria_bloc.dart';
import 'package:kgaona/bloc/categoria/categoria_event.dart';
import 'package:kgaona/bloc/categoria/categoria_state.dart';
import 'package:kgaona/components/custom_bottom_navigation_bar.dart';
import 'package:kgaona/components/side_menu.dart';
import 'package:kgaona/data/categoria_repository.dart';

class CategoriaScreen extends StatelessWidget {
  const CategoriaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoriaBloc(
        categoriaRepository: CategoriaRepository(),
      )..add(const CargarCategoriasEvent()), // Disparar el evento al iniciar
      child: const _CategoriaScreenView(),
    );
  }
}

class _CategoriaScreenView extends StatelessWidget {
  const _CategoriaScreenView();

  final int _selectedIndex = 2; // Posición en el menú de navegación

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías de Noticias'),
        centerTitle: true,
      ),
      drawer: const SideMenu(),
      backgroundColor: Colors.white,
      body: BlocBuilder<CategoriaBloc, CategoriaState>(
        builder: (context, state) {
          if (state is  CategoriaLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            // Estado inicial o cualquier otro estado no manejado
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // Siempre mostrar el indicador de carga ya que solo tenemos ese estado
          // if (state is CategoriaLoadingState) {
          //   return const Center(
          //     child: CircularProgressIndicator(),
          //   );
          // } 
          // else (state is CategoriaErrorState) {
          //   return Center(
          //     child: Text('Error: ${state.errorMessage}'),
          //   );
          // } 
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: _selectedIndex),
    );
  }
}