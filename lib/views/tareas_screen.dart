import 'package:flutter/material.dart';

class TareasScreen extends StatefulWidget {
  @override
  _TareasScreenState createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  final List<Map<String, String>> tareas = []; // Lista de tareas

  void _agregarTarea(String titulo, String detalle) {
    setState(() {
      tareas.add({'titulo': titulo, 'detalle': detalle});
    });
  }

  void _editarTarea(int index, String titulo, String detalle) {
    setState(() {
      tareas[index] = {'titulo': titulo, 'detalle': detalle};
    });
  }

  void _mostrarModalAgregarTarea({int? index}) {
    final TextEditingController tituloController = TextEditingController(
      text: index != null ? tareas[index]['titulo'] : '',
    );
    final TextEditingController detalleController = TextEditingController(
      text: index != null ? tareas[index]['detalle'] : '',
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(index == null ? 'Agregar Tarea' : 'Editar Tarea'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: detalleController,
                decoration: const InputDecoration(
                  labelText: 'Detalle',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el modal sin guardar
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final titulo = tituloController.text.trim();
                final detalle = detalleController.text.trim();

                if (titulo.isNotEmpty && detalle.isNotEmpty) {
                  if (index == null) {
                    _agregarTarea(titulo, detalle);
                  } else {
                    _editarTarea(index, titulo, detalle);
                  }
                  Navigator.pop(context); // Cierra el modal y guarda la tarea
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas'),
      ),
      body: tareas.isEmpty
          ? const Center(
              child: Text(
                'No hay tareas. Agrega una nueva tarea.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: tareas.length,
              itemBuilder: (context, index) {
                final tarea = tareas[index];
                return ListTile(
                  title: Text(tarea['titulo']!),
                  subtitle: Text(tarea['detalle']!),
                  onTap: () {
                    _mostrarModalAgregarTarea(index: index); // Editar tarea al tocar
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _mostrarModalAgregarTarea(index: index); // Editar tarea
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarModalAgregarTarea(),
        tooltip: 'Agregar Tarea',
        child: const Icon(Icons.add),
      ),
    );
  }
}