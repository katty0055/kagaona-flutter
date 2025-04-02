import 'package:flutter/material.dart';
import 'welcome_screen.dart'; // Importa la pantalla de bienvenida

class TareasScreen extends StatefulWidget {
  @override
  _TareasScreenState createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  List<Map<String, dynamic>> tareas = [];

  void _mostrarModal({Map<String, dynamic>? tarea, int? index}) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController tituloController = TextEditingController(
      text: tarea?['titulo'] ?? '',
    );
    final TextEditingController descripcionController = TextEditingController(
      text: tarea?['descripcion'] ?? '',
    );
    // DateTime? fechaPlazo = tarea?['fechaPlazo'];
    final TextEditingController fechaController = TextEditingController(
      text:
          tarea?['fechaPlazo'] != null
              ? tarea!['fechaPlazo'].toLocal().toString().split(' ')[0]
              : '',
    );
    DateTime? fechaPlazo = tarea?['fechaPlazo'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(tarea == null ? 'Agregar Tarea' : 'Editar Tarea'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: tituloController,
                    decoration: InputDecoration(
                      labelText: 'Título',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El título es obligatorio';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: descripcionController,
                    decoration: InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La descripción es obligatoria';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 10),
                  TextFormField(
                    controller: fechaController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Fecha Plazo',
                      hintText: 'Seleccionar Fecha',
                      border: OutlineInputBorder(),
                    ),
                    onTap: () async {
                      DateTime? fechaSeleccionada = await showDatePicker(
                        context: context,
                        initialDate: fechaPlazo ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (fechaSeleccionada != null) {
                        setState(() {
                          fechaPlazo = fechaSeleccionada;
                          fechaController.text =
                              fechaPlazo!.toLocal().toString().split(
                                ' ',
                              )[0]; // Actualiza el campo de texto
                        });
                      }
                    },
                    validator: (value) {
                      if (fechaPlazo == null) {
                        return 'La fecha es obligatoria';
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
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final nuevaTarea = {
                    'titulo': tituloController.text,
                    'descripcion': descripcionController.text,
                    'fechaPlazo': fechaPlazo,
                  };
                  setState(() {
                    if (tarea == null) {
                      tareas.add(nuevaTarea);
                    } else {
                      tareas[index!] = nuevaTarea;
                    }
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text(tarea == null ? 'Agregar' : 'Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Tareas')),
      body: ListView.builder(
        itemCount: tareas.length,
        itemBuilder: (context, index) {
          final tarea = tareas[index];
          return ListTile(
            title: Text(tarea['titulo']),
            subtitle: Text(tarea['descripcion'] ?? ''),
            trailing: Text(
              tarea['fechaPlazo'] != null
                  ? tarea['fechaPlazo'].toLocal().toString().split(' ')[0]
                  : '',
            ),
            onTap: () => _mostrarModal(tarea: tarea, index: index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarModal(),
        child: Icon(Icons.add),
      ),
    );
  }
}
