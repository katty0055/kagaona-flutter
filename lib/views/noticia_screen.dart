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
  int _numeroPagina = 1;
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
        _numeroPagina = 1;
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
      backgroundColor: Colors.grey[200], // Fondo de pantalla
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
                        return Column(
                          children: [
                            _buildNoticiaCard(noticia),
                            const SizedBox(height: Constants.espaciadoAlto), // Separación entre Cards
                          ],
                        );
                      },
                    ),
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: _selectedIndex),
    );
  }

  Widget _buildNoticiaCard(Noticia noticia) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        shape: CommonWidgetsHelper.buildRoundedBorder(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonWidgetsHelper.buildBoldTitle(noticia.titulo), // Título en negrita
              CommonWidgetsHelper.buildSpacing(),
              CommonWidgetsHelper.buildInfoLines(noticia.descripcion), // Descripción (máximo 3 líneas)
              CommonWidgetsHelper.buildSpacing(),
              Text(
                'Fuente: ${noticia.fuente}',
                style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
              ), // Fuente en cursiva
              CommonWidgetsHelper.buildSpacing(),
              Text(
                'Publicado el: ${_formatDate(noticia.publicadaEl)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ), // Fecha en formato dd/MM/yyyy HH:mm
            ],
          ),
        ),
      ),
    );
  }

   String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}