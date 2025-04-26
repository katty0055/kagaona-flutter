import 'package:flutter/material.dart';
import 'package:kgaona/components/add_button.dart';
import 'package:kgaona/components/last_updated_header.dart';
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

class CategoriaScreen extends StatefulWidget {
  const CategoriaScreen({super.key});

  @override
  State<CategoriaScreen> createState() => _CategoriaScreenState();
}

class _CategoriaScreenState extends State<CategoriaScreen> {
  final CategoriaRepository _categoriaRepository = CategoriaRepository();
  final int _selectedIndex = 2; // Posición en el menú de navegación
  
  List<Categoria> _categorias = [];
  bool _isLoading = false;
  bool _hasError = false;
  DateTime? _lastUpdated;

  @override
  void initState() {
    super.initState();
    _cargarCategorias();
  }

  Future<void> _cargarCategorias({bool mostrarMensaje = true}) async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final categorias = await _categoriaRepository.obtenerCategorias();
      setState(() {
        _categorias = categorias;
        _lastUpdated = DateTime.now();
        _isLoading = false;
      });

      // Mostrar mensaje de éxito cuando la carga es correcta (código 200)
      if (mounted && mostrarMensaje) {
        if(_categorias.isEmpty) {
          SnackBarHelper.mostrarInfo(
            context,
            mensaje: 'No hay categorías disponibles',
          );
        } else {
          SnackBarHelper.mostrarExito(
            context,
            mensaje: 'Categorias cargadas correctamente',
          );
        }       
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });

      if (mounted) {
        ErrorProcessorHelper.manejarError(
          context,
          e,
          mensajePredeterminado: 'Error al cargar categorias',
        );
      }
    }
  } 

  Future<void> _mostrarModalAgregarCategoria() async {
    final categoria = await ModalHelper.mostrarDialogo<Categoria>(
      context: context,
      title: 'Agregar Categoría',
      //borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: const FormularioCategoria(),
    );

    if (categoria != null) {
      try {
        // Capturar el mensaje que retorna el servicio
        await _categoriaRepository.crearCategoria(categoria);
        
        if (!mounted) return;
            
        // Mostrar mensaje de éxito cuando la carga es correcta (código 200)
        SnackBarHelper.mostrarExito(
          context,
          mensaje: 'Categoria creada exitosamente',
        );

        // Esperar a que termine la animación del SnackBar antes de recargar
        await Future.delayed(const Duration(milliseconds: 1500));

        _cargarCategorias(mostrarMensaje: false);
        
      } catch (e) {
         if (mounted) {
          ErrorProcessorHelper.manejarError(
            context,
            e,
            mensajePredeterminado: 'Ha ocurrido un error al crear la categoria',
          );
        }
      }
    }
  }

  // Método para mostrar el modal de editar categoría (integrado desde categoria_helper2)
  Future<void> _mostrarModalEditarCategoria(Categoria categoria) async {
    final categoriaEditada = await ModalHelper.mostrarDialogo<Categoria>(
     context: context,
     title: 'Editar Categoría',
      //borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: FormularioCategoria(categoria: categoria),
    );

    if (categoriaEditada != null && context.mounted) {
      try {
        setState(() {
          _isLoading = true;
        });
        // Capturar el mensaje que retorna el servicio
        await _categoriaRepository.actualizarCategoria(categoria.id!, categoriaEditada);
        
        if (mounted) {
           SnackBarHelper.mostrarExito(
            context,
            mensaje: 'Categoria actualizada exitosamente',
          );
          
          setState(() {
            final index = _categorias.indexWhere((c) => c.id == categoriaEditada.id);
            if (index != -1) {
              _categorias[index] = categoriaEditada;
              _lastUpdated = DateTime.now();
              _isLoading = false;
            }
          });
        }
      } catch (e) {
        if (mounted) {
          ErrorProcessorHelper.manejarError(
            context,
            e,
            mensajePredeterminado: 'Ha ocurrido un error al editar la categoria',
          );
        }
      }
    }
  }

  void _eliminarCategoria(Categoria categoria) async {
    // Confirmar eliminación
    final confirmar = await DialogHelper.mostrarConfirmacion(
      context: context,
      titulo: 'Confirmar eliminación',
      mensaje: '¿Estás seguro de eliminar la categoría "${categoria.nombre}"?',
      textoCancelar: 'Cancelar',
      textoConfirmar: 'Eliminar',
    );

    if (confirmar == true && categoria.id != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _categoriaRepository.eliminarCategoria(categoria.id!);
        
        setState(() {
          _categorias.removeWhere((element) => element.id == categoria.id);
          _lastUpdated = DateTime.now();
          _isLoading = false;
        });

        if (mounted) {
          SnackBarHelper.mostrarExito(
            context,
            mensaje: 'Categoria eliminada exitosamente',
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          ErrorProcessorHelper.manejarError(
            context,
            e,
            mensajePredeterminado: 'Ha ocurrido un error al eliminar la categoria',
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías de Noticias'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarCategorias,
          ),
        ],
      ),
      drawer: const SideMenu(),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          LastUpdatedHeader(lastUpdated: _lastUpdated),
          AddButton(
            text: 'Agregar Categoria',
            onPressed: () => _mostrarModalAgregarCategoria(),
          ),
          Expanded(
            child: _construirCuerpoCategorias(),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: _selectedIndex),
    );
  }

  Widget _construirCuerpoCategorias() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Ha ocurrido un error al cargar las categorías',
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _cargarCategorias,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    } else if (_categorias.isEmpty) {
      return const Center(child: Text('No hay categorías disponibles'));
    } else {
      return ListView.builder(
        itemCount: _categorias.length,
        itemBuilder: (context, index) {
          final categoria = _categorias[index];
          return CategoriaCard(
            categoria: categoria,
            onEdit: () => _mostrarModalEditarCategoria(categoria),
            onDelete: () => _eliminarCategoria(categoria),
          );
        },
      );
    }
  }
}

