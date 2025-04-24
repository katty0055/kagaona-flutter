import 'package:flutter/material.dart';
import 'package:kgaona/domain/noticia.dart';

class FormularioAgregarNoticia extends StatefulWidget {
  final Noticia? noticia; // Noticia existente para edición (null para creación)

  const FormularioAgregarNoticia({super.key, this.noticia});

  @override
  State<FormularioAgregarNoticia> createState() => _FormularioAgregarNoticiaState();
}

class _FormularioAgregarNoticiaState extends State<FormularioAgregarNoticia> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _descripcionController;
  late TextEditingController _fuenteController;
  late TextEditingController _imagenUrlController;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.noticia?.titulo ?? '');
    _descripcionController = TextEditingController(text: widget.noticia?.descripcion ?? '');
    _fuenteController = TextEditingController(text: widget.noticia?.fuente ?? '');
    _imagenUrlController = TextEditingController(text: widget.noticia?.imagenUrl ?? '');
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    _fuenteController.dispose();
    _imagenUrlController.dispose();
    super.dispose();
  }

  void _guardarNoticia() {
    if (_formKey.currentState!.validate()) {
      final noticia = Noticia(
        id: widget.noticia?.id, // Solo se usa para edición
        titulo: _tituloController.text,
        descripcion: _descripcionController.text,
        fuente: _fuenteController.text,
        publicadaEl: widget.noticia?.publicadaEl ?? DateTime.now(),
        imagenUrl: _imagenUrlController.text.isNotEmpty
            ? _imagenUrlController.text
            : "https://picsum.photos/200/300", // Imagen por defecto
      );
      Navigator.of(context).pop(noticia); // Devuelve la noticia al helper
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: 'Título'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El título no puede estar vacío';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descripcionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'La descripción no puede estar vacía';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _fuenteController,
              decoration: const InputDecoration(labelText: 'Fuente'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'La fuente no puede estar vacía';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _imagenUrlController,
              decoration: const InputDecoration(labelText: 'URL de la Imagen'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'La URL de la imagen no puede estar vacía';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _guardarNoticia,
              child: Text(widget.noticia == null ? 'Crear Noticia' : 'Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}