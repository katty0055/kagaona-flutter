import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  late TextEditingController _fechaController; // Nuevo controlador para la fecha
  DateTime _fechaSeleccionada = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.noticia?.titulo ?? '');
    _descripcionController = TextEditingController(text: widget.noticia?.descripcion ?? '');
    _fuenteController = TextEditingController(text: widget.noticia?.fuente ?? '');
    _imagenUrlController = TextEditingController(text: widget.noticia?.imagenUrl ?? '');
  
    // Inicializar fecha con la de la noticia o la actual
    _fechaSeleccionada = widget.noticia?.publicadaEl ?? DateTime.now();
    _fechaController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(_fechaSeleccionada)
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    _fuenteController.dispose();
    _imagenUrlController.dispose();
    _fechaController.dispose(); // Limpiar el nuevo controlador
    super.dispose();
  }

  // Método para mostrar el selector de fecha
  Future<void> _seleccionarFecha() async {
    // Asegurarse de que el contexto está disponible
    if (!context.mounted) return;
    
    try {
      final DateTime? fechaSeleccionada = await showDatePicker(
        context: context,
        initialDate: _fechaSeleccionada,
        firstDate: DateTime(2000),
        lastDate: DateTime.now().add(const Duration(days: 1)), // Permitir hasta hoy
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Theme.of(context).primaryColor,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          );
        },
      );

      if (fechaSeleccionada != null) {
        setState(() {
          _fechaSeleccionada = fechaSeleccionada;
          _fechaController.text = DateFormat('dd/MM/yyyy').format(fechaSeleccionada);
        });
      }
    } catch (e) {
      // En caso de error, mostrar un mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al mostrar el selector de fecha: $e")),
      );
    }
  }

  void _guardarNoticia() {
    if (_formKey.currentState!.validate()) {
      final noticia = Noticia(
        id: widget.noticia?.id, // Solo se usa para edición
        titulo: _tituloController.text,
        descripcion: _descripcionController.text,
        fuente: _fuenteController.text,
        publicadaEl:_fechaSeleccionada,
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
            // Campo de fecha con selector
            TextFormField(
              controller: _fechaController,
              decoration: const InputDecoration(
                labelText: 'Fecha de publicación',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true, // El usuario no puede editar el texto directamente
              onTap: _seleccionarFecha, // Mostrar el selector de fecha al tocar
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'La fecha no puede estar vacía';
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