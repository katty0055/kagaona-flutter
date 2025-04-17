import 'package:flutter/material.dart';
import 'package:kgaona/api/service/noticia_service.dart';
import 'package:kgaona/components/custom_bottom_navigation_bar.dart';
import 'package:kgaona/components/noticia_card.dart';
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
                        return NoticiaCard(noticia:noticia);
                      },
                    ),
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: _selectedIndex),
    );
  }
}