import 'package:flutter/material.dart';
import 'package:kgaona/domain/categoria.dart';
import 'package:kgaona/theme/theme.dart';

class FormularioCategoria extends StatefulWidget {
  final Categoria? categoria; // Categoría existente para edición (null para creación)

  const FormularioCategoria({super.key, this.categoria});

  @override
  State<FormularioCategoria> createState() => _FormularioCategoriaState();
}

class _FormularioCategoriaState extends State<FormularioCategoria> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _imagenUrlController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.categoria?.nombre ?? '');
    _descripcionController = TextEditingController(text: widget.categoria?.descripcion ?? '');
    _imagenUrlController = TextEditingController(text: widget.categoria?.imagenUrl ?? '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _imagenUrlController.dispose();
    super.dispose();
  }

  void _guardarCategoria() {
    if (_formKey.currentState!.validate()) {
      final categoria = Categoria(
        id: widget.categoria?.id, // Solo se usa para edición
        nombre: _nombreController.text,
        descripcion: _descripcionController.text,
        imagenUrl: _imagenUrlController.text.isNotEmpty
            ? _imagenUrlController.text
            : "https://picsum.photos/200/300", // Imagen por defecto
      );
      Navigator.of(context).pop(categoria); // Devuelve la categoría al helper
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.categoria == null ? 'Agregar Categoría' : 'Editar Categoría',
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Volver a usar TextFormField para mantener las validaciones
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre no puede estar vacío';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La descripción no puede estar vacía';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _imagenUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL de la imagen',
                  suffixIcon: Icon(Icons.image),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La URL de la imagen no puede estar vacía';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: AppTheme.modalSecondaryButtonStyle(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _guardarCategoria,
          style: AppTheme.modalActionButtonStyle(),
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}