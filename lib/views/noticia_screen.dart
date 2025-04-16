import 'package:flutter/material.dart';
import 'package:kgaona/api/service/noticia_service.dart';
import 'package:kgaona/components/custom_bottom_navigation_bar.dart';
import 'package:kgaona/components/side_menu.dart';
import 'package:kgaona/domain/noticia.dart';
import 'package:kgaona/helpers/task_card_helper.dart';
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
        _numeroPagina = 0;
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
        numeroPagina: _numeroPagina + 1,
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
                        return 
                        // Column(
                        //   children: [
                            _buildNoticiaCard(noticia);
                            //const SizedBox(height: Constants.espaciadoAlto), // Separación entre Cards
                         // ],
                       // );
                      },
                    ),
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: _selectedIndex),
    );
  }

  Widget _buildNoticiaCard(Noticia noticia) {
  return Column(
    children: [
      Card(
        margin: EdgeInsets.zero,
        color: Colors.white, // Fondo blanco del Card
        shape: null, // Sin bordes redondeados
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 12.0), // Padding general para el contenido
          child: Column(
            children: [
              // Primera fila: Texto y la imagen
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding horizontal de 16
                child: Row(
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
                          const SizedBox(height: 2.0),
                          Text(
                            noticia.descripcion,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Fuente: ${noticia.fuente}',
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'Publicado el: ${_formatDate(noticia.publicadaEl)}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 30),
                    // Imagen (1/3 del ancho)
                    //Padding(
                     // padding: const EdgeInsets.only(right: 16.0), // Padding derecho para la imagen
                      //child:
                       ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Image.network(
                          'https://picsum.photos/100/100?random=${noticia.hashCode}',
                          height: 80, // Altura de la imagen
                          width: 105,
                          fit: BoxFit.cover,
                        ),
                      ),
                    //),
                  ],
                ),
              ),
              //const SizedBox(height: 8.0), // Espaciado entre la fila de contenido y los botones
              // Segunda fila: Botones alineados al final
              Row(
                mainAxisAlignment: MainAxisAlignment.end, // Alinea los botones al final
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {
                      // Acción para marcar como favorito
                      print('Favorito presionado');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {
                      // Acción para compartir
                      print('Compartir presionado');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      // Acción para mostrar más opciones
                      print('Más opciones presionado');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      const Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.0), // Padding horizontal de 16
      child: Divider(),
    ),
    ],
  );
}


   String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}