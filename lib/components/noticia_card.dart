import 'package:flutter/material.dart';
import 'package:kgaona/constants.dart';
import 'package:kgaona/domain/noticia.dart';
import 'package:intl/intl.dart';

class NoticiaCard extends StatelessWidget {
  final Noticia noticia;

  const NoticiaCard({super.key, required this.noticia});

  @override
  Widget build(BuildContext context) {
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
                              fontSize: 18,
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
                        errorBuilder: (context, error, stackTrace) {
                          // Widget alternativo cuando la imagen no carga
                          return Container(
                            height: 80,
                            width: 100,
                            color: Colors.grey[300], // Fondo gris claro
                            child: const Icon(
                              Icons.broken_image, // Ícono de imagen rota
                              color: Colors.grey,
                              size: 40,
                            ),
                          );
                        },
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
    return DateFormat(Constants.formatoFecha).format(date);
  }
}