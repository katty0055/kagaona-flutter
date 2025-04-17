import 'package:flutter/material.dart';
import 'package:kgaona/api/service/noticia_service.dart';
import 'package:kgaona/components/custom_bottom_navigation_bar.dart';
import 'package:kgaona/components/side_menu.dart';
import 'package:kgaona/domain/noticia.dart';
import 'package:kgaona/constants.dart';

class NoticiaScreen extends StatefulWidget {
  const NoticiaScreen({super.key});

  @override
  NoticiaScreenState createState() => NoticiaScreenState();
}

class NoticiaScreenState extends State<NoticiaScreen> {
  final NoticiaService _noticiaService = NoticiaService();
  final ScrollController _scrollController = ScrollController();
  final int _selectedIndex = 0;

  List<Noticia> _noticias = [];
  int _numeroPagina = 0;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadInitialNoticias();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent && !_isLoading && _hasMore) {
        _loadMoreNoticias();
      }
    });
  }

  Future<void> _loadInitialNoticias() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final noticias = await _noticiaService.obtenerNoticiasIniciales();
      setState(() {
        _noticias = noticias;
        _numeroPagina;
        _hasMore = noticias.isNotEmpty;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(Constants.errorMessage)),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _numeroPagina++;
        });
      }
    }
  }

  Future<void> _loadMoreNoticias() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final nuevasNoticias = await _noticiaService.obtenerNoticiasPaginadas(
        numeroPagina: _numeroPagina,
        tamanoPagina: Constants.pageSize,
      );

      setState(() {
        _noticias.addAll(nuevasNoticias);
        _numeroPagina++;
        _hasMore = nuevasNoticias.isNotEmpty;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(Constants.errorMessage)),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
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
        title: const Text(Constants.tituloApp),
        centerTitle: true,
      ),
      drawer: const SideMenu(),
      backgroundColor: Colors.white, // Fondo de pantalla
      body: _isLoading && _noticias.isEmpty
          ? const Center(child: Text(Constants.mensajeCargando)) // mensajeCargando
          : _hasError
              ? const Center(child: Text(Constants.mensajeError)) // mensajeError
              : _noticias.isEmpty
                  ? const Center(child: Text(Constants.listaVacia)) // listaVacia
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: _noticias.length + (_hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _noticias.length) {
                          return const Center(child: CircularProgressIndicator()); // Indicador de carga
                        }

                        final noticia = _noticias[index];
                        return _buildNoticiaCard(noticia);
                      },
                    ),
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: _selectedIndex),
    );
  }

  Widget _buildNoticiaCard(Noticia noticia) {
  return Column(
    children: [
      Card(
        margin: const EdgeInsets.only(top:16.0, bottom: 0.0, left: 0.0, right: 0.0), // Margen de la tarjeta
        color: Colors.white, 
        shape: null, 
        elevation: 0.0,
          child: Column(
            children: [
              // Primera fila: Texto y la imagen   
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),          
                child:Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Columna para el texto (2/3 del ancho)
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            noticia.titulo,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            noticia.descripcion,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6.0),
                          Text(
                            noticia.fuente,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            _formatDate(noticia.publicadaEl),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 30),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.network(
                        'https://picsum.photos/100/100?random=${noticia.hashCode}',
                        height: 80, // Altura de la imagen
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end, // Alinea los botones al final
                children: [
                  IconButton(
                    icon: const Icon(Icons.star_border),
                    onPressed: () {
                      // Acción para marcar como favorito
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {
                      // Acción para compartir
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      // Acción para mostrar más opciones
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 0.0), // Padding horizontal de 16
          child:Divider(
            color: Colors.grey, 
          ),
        ),
      ],
  );
}


   String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}