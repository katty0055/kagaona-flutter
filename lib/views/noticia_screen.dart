import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kgaona/api/service/categoria_service.dart';
import 'package:kgaona/api/service/noticia_service.dart';
import 'package:kgaona/components/custom_bottom_navigation_bar.dart';
import 'package:kgaona/components/side_menu.dart';
import 'package:kgaona/constants.dart';
import 'package:kgaona/domain/categoria.dart';
import 'package:kgaona/domain/noticia.dart';
import 'package:kgaona/helpers/noticia_helper.dart';

class NoticiaScreen extends StatefulWidget {
  const NoticiaScreen({super.key});
  @override
  NoticiaScreenState createState() => NoticiaScreenState();
}

class NoticiaScreenState extends State<NoticiaScreen> {
  final NoticiaService _noticiaService = NoticiaService();
  final CategoriaService _categoriaService = CategoriaService();
  final ScrollController _scrollController = ScrollController();
  final int _selectedIndex = 0;

  List<Noticia> _noticias = [];
  List<Category> _categorias = [];
  int _numeroPagina = 1;
  bool _isLoading = false;
  bool _hasError = false; // Cambiado de _errorMessage a _hasError
  String? _errorMessage; // Mantener para mensajes específicos
  bool _hasMore = true;
  DateTime? _lastUpdated; // Nueva variable para almacenar la última actualización
  bool _mostrarIndicadorCarga = true; // Nueva variable para controlar el indicador

  @override
  void initState() {
    super.initState();
    _loadNoticias(cargaInicial: true);
    _cargarCategorias(); // Añadir esta línea
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _hasMore) {
        _loadNoticias();
      }
    });
  }

  Future<void> _loadNoticias({bool cargaInicial = false}) async {
    setState(() {
      _isLoading = true;
      if (cargaInicial) {
        _hasError = false;
        _errorMessage = null;
      }
    });

    try {
      final nuevasNoticias = await _noticiaService.obtenerNoticias(
        numeroPagina: _numeroPagina,
        tamanoPagina: Constants.pageSize,
        cargaInicial: cargaInicial,
      );

      setState(() {
        if (cargaInicial) {
          _noticias = nuevasNoticias;
        } else {
          _noticias.addAll(nuevasNoticias);
        }
        _numeroPagina++;
        _hasMore = nuevasNoticias.length == Constants.pageSize;
        _lastUpdated = DateTime.now(); // Actualizar la fecha y hora
        _isLoading = false;
        _hasError = false;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _reiniciar() async {
  // Primero, establece las variables de estado iniciales
  setState(() {
    // Resetear todas las variables a su estado inicial
    _noticias = []; // Vaciar la lista
    _numeroPagina = 1; // Resetear a primera página
    _mostrarIndicadorCarga = false; // Ocultar indicador de carga al scrollear
    _hasError = false;
    _errorMessage = null;
  });
  
  // Luego, reutiliza el método loadNoticias existente
  await _loadNoticias(cargaInicial: true);
  
  // Hacer scroll al inicio de la lista
  if (_scrollController.hasClients) {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
  
  // Restaurar el indicador de carga después de un tiempo
  Future.delayed(const Duration(seconds: 5), () {
    if (mounted) {
      setState(() {
        _mostrarIndicadorCarga = true;
      });
    }
  });
}

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Añadir este método para cargar las categorías
  Future<void> _cargarCategorias() async {
    try {
      final categorias = await _categoriaService.obtenerCategorias();
      setState(() {
        _categorias = categorias;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al cargar las categorías'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
        // Podemos mostrar la última actualización en la UI
    String lastUpdatedText = _lastUpdated != null 
        ? 'Última actualización: ${DateFormat(Constants.formatoFecha).format(_lastUpdated!)}'
        : 'No actualizado aún';
        
    return Scaffold(
      appBar: AppBar(
        title: const Text(ConstantesNoticias.tituloApp),
        centerTitle: true,
      ),
      drawer: const SideMenu(),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Mostrar la última fecha de actualización
          if (_lastUpdated != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Text(
                lastUpdatedText,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          TextButton(
            onPressed: () => mostrarModalAgregarNoticia(
              context: context,
              noticiaService: _noticiaService,
              categoriaService: _categoriaService,
              onReinciar: _reiniciar, // Usar el método modificado
            ),
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
                Text('Agregar Noticia', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          Expanded(
            child: construirCuerpoNoticias(
              isLoading: _isLoading,
              errorMessage: _errorMessage,
              hasError: _hasError,
              noticias: _noticias,
              hasMore: _hasMore,
              scrollController: _scrollController,
              context: context,
              noticiaService: _noticiaService,
              categorias: _categorias, // Pasar la lista de categorías que ya tienes cargada
              onEdit: (noticia, index) {
                mostrarModalEditarNoticia(
                  context: context,
                  noticiaService: _noticiaService,
                  categoriaService: _categoriaService, // Añadir este parámetro
                  noticia: noticia,
                  onNoticiaEditada: (noticiaEditada) {
                    setState(() {
                      _noticias[index] = noticiaEditada;
                    });
                  },
                );
              },
              onDelete: (noticia, index) {
                eliminarNoticia(
                  context: context,
                  noticiaService: _noticiaService,
                  noticia: noticia,
                  onNoticiaEliminada: () {
                    setState(() {
                      _noticias.removeAt(index);
                      _lastUpdated = DateTime.now(); // Actualizar después de eliminar
                    });
                  },
                );
              },
              onRetry: () => _loadNoticias(cargaInicial: true),
              mostrarIndicadorCarga: _mostrarIndicadorCarga,
            ),
          ),          
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: _selectedIndex),
    );
  }
}