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
    final TextEditingController titlecontroller = TextEditingController();
    final TextEditingController descriptioncontroller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Agregar tarea'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titlecontroller,
                decoration: InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: descriptioncontroller,
                decoration: InputDecoration(labelText: 'Descripción'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final title = titlecontroller.text.trim();
                final detalle = descriptioncontroller.text.trim();
                _agregarTarea(title, detalle);
                Navigator.of(context).pop();
              },
              child: Text('Agregar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tareas')),
      body:
          tareas.isEmpty
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
                      _mostrarModalAgregarTarea(
                        index: index,
                      ); // Editar tarea al tocar
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
