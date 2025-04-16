import 'dart:math';
import 'package:kgaona/domain/noticia.dart';

class NoticiaRepository {
  final Random _random = Random();

  final List<Noticia> _noticias = List.generate(
    15,
    (index) {
      final random = Random();
      return Noticia(
        titulo: 'Noticia Repository ${index + 1}',
        descripcion: 'Descripción de la noticia ${index + 1}. Esta es una descripción detallada.',
        fuente: 'Fuente ${index % 5 + 1}', // Alterna entre 5 fuentes
        publicadaEl: DateTime.now().subtract(Duration(days: random.nextInt(30))), // Fecha aleatoria en los últimos 30 días
      );
    },
  );

  // Simula la obtención de noticias iniciales
  Future<List<Noticia>> fetchNoticias() async {
    await Future.delayed(const Duration(seconds: 2)); // Simula el retraso de una API
    return _noticias;
  }

  // Genera nuevas noticias aleatorias para scroll infinito
  Future<List<Noticia>> fetchMoreNoticias(int pageNumber, int pageSize) async {
   await Future.delayed(const Duration(seconds: 2)); // Simula el retraso de una API

    //final startId = _noticias.length + 1 + (pageNumber - 1) * pageSize;
    //final startId = _noticias.length + 1 + ((pageNumber - 1) * pageSize);
    final startId = _noticias.length + 1 ;
    
    final nuevasNoticias = List.generate(
      pageSize,
      (index) => Noticia(
        titulo: 'Noticia Aleatoria ${startId + index}',
        descripcion: 'Contenido generado aleatoriamente para la noticia ${startId + index}.',
        fuente: 'Fuente ${_random.nextInt(5) + 1}', // Genera una fuente aleatoria entre 1 y 5
        publicadaEl: DateTime.now().subtract(Duration(days: _random.nextInt(30))), // Fecha aleatoria en los últimos 30 días
      ),
    );

    _noticias.addAll(nuevasNoticias); // Agrega las nuevas noticias a la lista existente
    return nuevasNoticias;
  }
}