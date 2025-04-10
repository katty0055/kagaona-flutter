/*
¿Cómo controla el estado los cambios de color? ¿Qué hace Column en este layout?
Con una lista de colores y el setState() dentro de la funcion cambiarColor()> Se le suma 1 al indice actual y 
se obtiene el resto de la division con el tamaño de la lista de colores,el rersultado 
es el nuevo indice del color a mostrar. 
Column alinea a los widgets hijos uno detras de otro.
*/

import 'package:flutter/material.dart';
import 'package:kgaona/components/custom_bottom_navigation_bar.dart';

class MiAppScreen extends StatefulWidget {
  const MiAppScreen({super.key});

  @override
  _MiAppScreenState createState() => _MiAppScreenState();
}

class _MiAppScreenState extends State<MiAppScreen> {
  Color _colorActual = Colors.blue; // Color inicial del Container
  final List<Color> _colores = [Colors.blue, Colors.red, Colors.green];
  int _indiceColor = 0;
  final int _selectedIndex = 0;

  void _cambiarColor() {
    setState(() {
      _indiceColor = (_indiceColor + 1) % _colores.length; // Cambia al siguiente color
      _colorActual = _colores[_indiceColor];
    });
  }
  
  void _resetColor() {
    setState(() {
      _colorActual = Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi App'),
      ),
      body: Center(
        child: Wrap(          
          children: [
            Container(
              width: 300,
              height: 300,
              color: _colorActual, // Aplica el color actual
              alignment: Alignment.center,
              child: const Text(
                '¡Cambio de color!',
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _cambiarColor, // Cambia el color al presionar
              child: const Text('Cambiar Color'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _resetColor, // Cambia el color al presionar
              child: const Text('Resetea Color'),
            ),
          ],
        ),
      ),
       bottomNavigationBar:  CustomBottomNavigationBar(selectedIndex: _selectedIndex),
    );
  }
}