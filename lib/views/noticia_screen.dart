import 'package:flutter/material.dart';
import 'package:kgaona/components/add_button.dart';
import 'package:kgaona/components/custom_bottom_navigation_bar.dart';
import 'package:kgaona/components/formulario_noticia.dart';
import 'package:kgaona/components/last_updated_header.dart';
import 'package:kgaona/components/noticia_card.dart';
import 'package:kgaona/components/side_menu.dart';
import 'package:kgaona/components/snackbar_component.dart';
import 'package:kgaona/constants/constants.dart';
import 'package:kgaona/data/categoria_repository.dart';
import 'package:kgaona/data/noticia_repository.dart';
import 'package:kgaona/domain/categoria.dart';
import 'package:kgaona/domain/noticia.dart';
import 'package:kgaona/helpers/categoria_helper.dart';
import 'package:kgaona/helpers/dialog_helper.dart';
import 'package:kgaona/helpers/error_processor_helper.dart';
import 'package:kgaona/helpers/modal_helper.dart';
import 'package:kgaona/helpers/snackbar_helper.dart';
import 'package:kgaona/views/categoria_screen.dart';

class NoticiaScreen extends StatefulWidget {
  const NoticiaScreen({super.key});
  @override
  NoticiaScreenState createState() => NoticiaScreenState();
}

class NoticiaScreenState extends State<NoticiaScreen> {
  // Repositorios
  final NoticiaRepository _noticiaRepository = NoticiaRepository();
  final CategoriaRepository _categoriaRepository = CategoriaRepository();

  // Controllers y estado de UI
  final ScrollController _scrollController = ScrollController();
  final int _selectedIndex = 0;
  List<Noticia> _noticias = [];
  List<Categoria> _categorias = [];
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;
  bool _hasMore = true;
  DateTime? _lastUpdated;
  final bool _mostrarIndicadorCarga = true;

  @override
  void initState() {
    super.initState();
    _loadNoticias(cargaInicial: true);
    _cargarCategorias();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _hasMore) {
        _loadNoticias();
      }
    });
  }

  Future<void> _loadNoticias({
    bool cargaInicial = false,
    bool mostrarMensaje = true,
  }) async {
    setState(() {
      _isLoading = true;
      if (cargaInicial) {
        _hasError = false;
        _errorMessage = null;
      }
    });

    try {
      final nuevasNoticias = await _noticiaRepository.obtenerNoticias();

      setState(() {
        if (cargaInicial) {
          _noticias = nuevasNoticias;
        } else {
          _noticias.addAll(nuevasNoticias);
        }
        _hasMore = nuevasNoticias.length == Constants.pageSize;
        _lastUpdated = DateTime.now();
        _isLoading = false;
        _hasError = false;
        _errorMessage = null;
      });

      // Mostrar mensaje de éxito cuando la carga es correcta (código 200)
      if (mounted && cargaInicial && mostrarMensaje) {
        if (_noticias.isEmpty) {
          // Mostrar mensaje cuando la lista está vacía pero es un 200 (éxito)
          SnackBarHelper.mostrarInfo(
            context,
            mensaje: 'No hay noticias disponibles por el momento',
          );
        } else {
          SnackBarHelper.mostrarExito(
            context,
            mensaje: 'Noticias cargadas correctamente',
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString();
      });

      if (mounted) {
        ErrorProcessorHelper.manejarError(
          context,
          e,
          mensajePredeterminado: 'Error al cargar noticias',
        );
      }
    }
  }

  Future<void> _cargarCategorias() async {
    try {
      final categorias = await _categoriaRepository.obtenerCategorias();
      setState(() {
        _categorias = categorias;
      });
    } catch (e) {
      if (mounted) {
        ErrorProcessorHelper.manejarError(
          context,
          e,
          mensajePredeterminado: 'Error al cargar categorias',
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ConstantesNoticias.tituloApp),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            tooltip: 'Categorías',
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
          LastUpdatedHeader(lastUpdated: _lastUpdated),
          AddButton(
            text: 'Agregar Noticia',
            onPressed: () => _mostrarModalAgregarNoticia(),
          ),
          Expanded(child: _construirCuerpoNoticias()),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
      ),
    );
  }

  // Construir el cuerpo de la vista de noticias
  Widget _construirCuerpoNoticias() {
    if (_isLoading && _noticias.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else if (_hasError && _noticias.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage ?? ConstantesNoticias.mensajeError,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _loadNoticias(cargaInicial: true),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    } else if (_noticias.isEmpty) {
      return const Center(child: Text(ConstantesNoticias.listaVacia));
    } else {
      return ListView.builder(
        controller: _scrollController,
        itemCount:
            _noticias.length + ((_hasMore && _mostrarIndicadorCarga) ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _noticias.length && _hasMore && _mostrarIndicadorCarga) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          }

          final noticia = _noticias[index];

          return Dismissible(
            key: Key(noticia.id ?? UniqueKey().toString()),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) async {
              return await DialogHelper.mostrarConfirmacion(
                context: context,
                titulo: 'Confirmar eliminación',
                mensaje: '¿Estás seguro de que deseas eliminar esta noticia?',
                textoCancelar: 'Cancelar',
                textoConfirmar: 'Eliminar',
              );
            },
            onDismissed: (direction) {
              _eliminarNoticia(noticia, index);
            },
            child: NoticiaCard(
              noticia: noticia,
              onEdit: () => _mostrarModalEditarNoticia(noticia, index),
              categoriaNombre: CategoriaHelper.obtenerNombreCategoria(
                noticia.categoriaId,
                _categorias,
              ),
            ),
          );
        },
      );
    }
  }

  // Método para mostrar el modal de agregar noticia
  Future<void> _mostrarModalAgregarNoticia() async {
    _cargarCategorias();
    final noticia = await ModalHelper.mostrarDialogo<Noticia>(
      context: context,
      title: 'Agregar noticia',
      //borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: FormularioNoticia(categorias: _categorias),
    );

    if (noticia != null) {
      try {
        await _noticiaRepository.crearNoticia(noticia);
        if (!mounted) return;
        
        // Mostrar mensaje de éxito cuando la carga es correcta (código 200)
        SnackBarHelper.mostrarExito(
          context,
          mensaje: 'Noticia creada exitosamente',
        );
        
        // Esperar a que termine la animación del SnackBar antes de recargar
        await Future.delayed(const Duration(milliseconds: 1500));
        if (!mounted) return;

        // Mostrar indicador de carga 
        setState(() {
          _isLoading = true;
          _noticias = [];
          _lastUpdated = DateTime.now();
        });
        
        // Cargar las noticias de nuevo SIN mostrar mensaje
        await _loadNoticias(cargaInicial: true, mostrarMensaje: false);
        
      } catch (e) {
        if (mounted) {
          ErrorProcessorHelper.manejarError(
            context,
            e,
            mensajePredeterminado: 'Ha ocurrido un error al crear la noticia',
          );
        }
      }
    }
  }

  // Método para mostrar el modal de editar noticia
  Future<void> _mostrarModalEditarNoticia(Noticia noticia, int index) async {
    _cargarCategorias();
    final noticiaEditada = await ModalHelper.mostrarDialogo<Noticia>(
      context: context,
      title: 'Editar noticia',
      //borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: FormularioNoticia(noticia: noticia, categorias: _categorias),
    );

    if (noticiaEditada != null) {
      try {
        await _noticiaRepository.editarNoticia(noticia.id!, noticiaEditada);

        if (!mounted) return;

        // Mostrar mensaje de éxito
        SnackBarHelper.mostrarExito(
          context,
          mensaje: 'Noticia actualizada exitosamente',
        );

        // Esperar a que termine la animación del SnackBar
        await Future.delayed(const Duration(milliseconds: 1500));
        
        if (!mounted) return;
      
        // Mostrar indicador de carga 
        setState(() {
          _isLoading = true;
          _noticias = [];
          _lastUpdated = DateTime.now();
        });
        
        // Cargar las noticias de nuevo SIN mostrar mensaje
        await _loadNoticias(cargaInicial: true, mostrarMensaje: false);

      } catch (e) {
        if (mounted) {
          ErrorProcessorHelper.manejarError(
            context,
            e,
            mensajePredeterminado: 'Ha ocurrido un error al editar la noticia',
          );
        }
      }
    }
  }

  // Método para eliminar una noticia
  Future<void> _eliminarNoticia(Noticia noticia, int index) async {
    try {
      if (noticia.id == null || noticia.id!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBarComponent.crear(
            mensaje: 'No se puede eliminar la noticia porque no tiene ID',
            color: Colors.red,
            duracion: const Duration(seconds: 4),
          ),
        );
        return;
      }

      await _noticiaRepository.eliminarNoticia(noticia.id!);

      // Mostrar indicador de carga 
      setState(() {
        _isLoading = true;
        _noticias = [];
        _lastUpdated = DateTime.now();
      });

      if (!mounted) return;
    
      SnackBarHelper.mostrarExito(
        context,
        mensaje: 'Noticia eliminada exitosamente',
      );

      // Esperar a que termine la animación del SnackBar
      await Future.delayed(const Duration(milliseconds: 1500));
        
      if (!mounted) return;        
      // Cargar las noticias de nuevo SIN mostrar mensaje
      await _loadNoticias(cargaInicial: true, mostrarMensaje: false);
    } catch (e) {
      if (mounted) {
        ErrorProcessorHelper.manejarError(
          context,
          e,
          mensajePredeterminado: 'Ha ocurrido un error al eliminar la noticia',
        );
      }
    }
  }
}
