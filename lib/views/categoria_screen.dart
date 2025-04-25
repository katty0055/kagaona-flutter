import 'package:flutter/material.dart';
import 'package:kgaona/api/service/categoria_service.dart';
import 'package:kgaona/components/categoria_card.dart';
import 'package:kgaona/components/side_menu.dart';
import 'package:kgaona/components/custom_bottom_navigation_bar.dart';
import 'package:kgaona/constants.dart';
import 'package:kgaona/domain/categoria.dart';
import 'package:intl/intl.dart';
import 'package:kgaona/exceptions/api_exception.dart';
// Importar el helper
import 'package:kgaona/helpers/categoria_helper.dart';
import 'package:kgaona/helpers/error_helper.dart';

class CategoriaScreen extends StatefulWidget {
  const CategoriaScreen({super.key});

  @override
  State<CategoriaScreen> createState() => _CategoriaScreenState();
}

class _CategoriaScreenState extends State<CategoriaScreen> {
  final CategoriaService _categoriaService = CategoriaService();
  final int _selectedIndex = 2; // Posición en el menú de navegación
  
  List<Category> _categorias = [];
  bool _isLoading = false;
  bool _hasError = false;
  // String? _errorMessage;
  DateTime? _lastUpdated;

  @override
  void initState() {
    super.initState();
    _cargarCategorias();
  }

  Future<void> _cargarCategorias() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      // _errorMessage = null;
    });

    try {
      final categorias = await _categoriaService.obtenerCategorias();
      setState(() {
        _categorias = categorias;
        _lastUpdated = DateTime.now();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        // _errorMessage = e.toString();
      });

      String errorMessage = 'Error desconocido';
      Color errorColor = Colors.grey;

      if (e is ApiException) {
        final errorData = ErrorHelper.getErrorMessageAndColor(e.statusCode);
        errorMessage = errorData['message'];
        errorColor = errorData['color'];
      }
      if (mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: errorColor),
        );
      }
    }
  } 

  void _mostrarModalAgregarCategoria() {
    // Esta función se implementará más tarde para permitir agregar categorías
    mostrarModalAgregarCategoria(
      context: context,
      categoriaService: _categoriaService,
      onCategoriaCreada: _cargarCategorias,
    );
  }  

  void _editarCategoria(Category categoria) {
    // Esta función se implementará más tarde para permitir editar categorías
    mostrarModalEditarCategoria(
      context: context,
      categoriaService: _categoriaService,
      categoria: categoria,
      onCategoriaEditada: (categoriaEditada) {
        setState(() {
          final index = _categorias.indexWhere((c) => c.id == categoriaEditada.id);
          if (index != -1) {
            _categorias[index] = categoriaEditada;
            _lastUpdated = DateTime.now();
          }
        });
      },
    );
  }

  void _eliminarCategoria(Category categoria) async {
    // Confirmar eliminación
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de eliminar la categoría "${categoria.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true && categoria.id != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _categoriaService.eliminarCategoria(categoria.id!);
        
        setState(() {
          _categorias.removeWhere((element) => element.id == categoria.id);
          _lastUpdated = DateTime.now();
          _isLoading = false;
        });

        if (mounted) {
          // Mensaje de éxito
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Categoría eliminada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        if (!mounted) return;
        
        String errorMessage = 'Error desconocido';
        Color errorColor = Colors.grey;

        if (e is ApiException) {
          final errorData = ErrorHelper.getErrorMessageAndColor(e.statusCode);
          errorMessage = errorData['message'];
          errorColor = errorData['color'];
        } else {
          // Si es otro tipo de excepción, usar el mensaje de la excepción
          errorMessage = e.toString().replaceAll('Exception: ', '');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: errorColor),
        );
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
          if (_lastUpdated != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Text(
                'Última actualización: ${DateFormat(Constants.formatoFecha).format(_lastUpdated!)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          TextButton(
            onPressed: () => _mostrarModalAgregarCategoria(),
            style: TextButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              backgroundColor: Theme.of(context).primaryColor,
              minimumSize: const Size(double.infinity, 48),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Colors.white),
                SizedBox(width: 8),
                Text('Agregar Categoría', style: TextStyle(color: Colors.white)),
              ],
            ),
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
            onEdit: () => _editarCategoria(categoria),
            onDelete: () => _eliminarCategoria(categoria),
          );
        },
      );
    }
  }
}

