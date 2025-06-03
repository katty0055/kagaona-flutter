import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgaona/bloc/comentario/comentario_bloc.dart';
import 'package:kgaona/bloc/comentario/comentario_event.dart';
import 'package:kgaona/bloc/comentario/comentario_state.dart';
import 'package:kgaona/domain/noticia.dart';
import 'package:kgaona/views/comentarios/components/comment_app_bar.dart';
import 'package:kgaona/views/comentarios/components/comment_card.dart';
import 'package:kgaona/views/comentarios/components/comment_input_form.dart';
import 'package:kgaona/views/comentarios/components/comment_search_bar.dart';
import 'package:kgaona/views/comentarios/components/noticia_cabecera.dart';

class ComentariosScreen extends StatelessWidget {
  final Noticia noticia;
  final String categoriaNombre;

  const ComentariosScreen({
    super.key,
    required this.noticia,
    this.categoriaNombre = "Sin categoría",
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ComentarioBloc>()..add(LoadComentarios(noticia.id!)),
      child: _ComentariosScreenContent(
        noticia: noticia,
        noticiaId: noticia.id!,
        noticiaTitulo: noticia.titulo,
        categoriaNombre: categoriaNombre,
      ),
    );
  }
}

class _ComentariosScreenContent extends StatefulWidget {
  final String noticiaId;
  final String noticiaTitulo;
  final Noticia noticia;
  final String categoriaNombre;

  const _ComentariosScreenContent({
    required this.noticiaId,
    required this.noticiaTitulo,
    required this.noticia,
    required this.categoriaNombre,
  });

  @override
  State<_ComentariosScreenContent> createState() =>
      _ComentariosScreenContentState();
}

class _ComentariosScreenContentState extends State<_ComentariosScreenContent> {
  final TextEditingController _comentarioController = TextEditingController();
  final TextEditingController _busquedaController = TextEditingController();
  bool _ordenAscendente = true;
  String? _respondingToId;
  String? _respondingToAutor;

  void _cancelarRespuesta() {
    setState(() {
      _respondingToId = null;
      _respondingToAutor = null;
      _comentarioController.clear();
    });
  }

  @override
  void dispose() {
    _comentarioController.dispose();
    _busquedaController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _recargarComentarios();
    });
  }

  void _recargarComentarios() {
    context.read<ComentarioBloc>().add(LoadComentarios(widget.noticiaId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommentAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NoticiaCabecera(
                noticia: widget.noticia,
                categoriaNombre: widget.categoriaNombre,
              ),
              CommentInputForm(
                noticiaId: widget.noticiaId,
                comentarioController: _comentarioController,
                respondingToId: _respondingToId,
                respondingToAutor: _respondingToAutor,
                onCancelarRespuesta: _cancelarRespuesta,
              ),
              const SizedBox(height: 16),
              CommentSearchBar(
                busquedaController: _busquedaController,
                onSearch: () => _handleSearch(),
                noticiaId: widget.noticiaId,
                ordenAscendente: _ordenAscendente,
                onOrdenChanged: (ascendente) {
                  setState(() => _ordenAscendente = ascendente);
                  context.read<ComentarioBloc>().add(
                    OrdenarComentarios(ascendente),
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<ComentarioBloc, ComentarioState>(
                builder: (context, state) {
                  if (state is ComentarioLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is ComentarioLoaded) {
                    if (state.comentarios.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Text('No hay comentarios disponibles'),
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.comentarios.length,
                      itemBuilder: (context, index) {
                        final comentario = state.comentarios[index];
                        return CommentCard(
                          comentario: comentario,
                          noticiaId: widget.noticiaId,
                          onResponder: (comentarioId, autor) {
                            setState(() {
                              _respondingToId = comentarioId;
                              _respondingToAutor = autor;
                            });
                          },
                        );
                      },
                    );
                  } else if (state is ComentarioError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Text('Error: ${state.error.message}'),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSearch() {
    if (_busquedaController.text.isEmpty) {
      context.read<ComentarioBloc>().add(LoadComentarios(widget.noticiaId));
    } else {
      context.read<ComentarioBloc>().add(
        BuscarComentarios(_busquedaController.text, widget.noticiaId),
      );
    }
  }
}
