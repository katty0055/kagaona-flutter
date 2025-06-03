/*
¿Cómo controla el estado los cambios de color? ¿Qué hace Column en este layout?
Con una lista de colores y el setState() dentro de la funcion cambiarColor()> Se le suma 1 al indice actual y 
se obtiene el resto de la division con el tamaño de la lista de colores,el rersultado 
es el nuevo indice del color a mostrar. 
Column alinea a los widgets hijos uno detras de otro.
*/

import 'package:flutter/material.dart';
import 'package:kgaona/components/side_menu.dart';
import 'package:kgaona/theme/colors.dart';

class MiAppScreen extends StatefulWidget {
  const MiAppScreen({super.key});

  @override
  MiAppScreenState createState() => MiAppScreenState();
}

class MiAppScreenState extends State<MiAppScreen> {
  Color _colorActual = AppColors.primaryDarkBlue; // Color inicial del Container
  final List<Color> _colores = [
    AppColors.primaryDarkBlue, 
    AppColors.error, 
    AppColors.success
  ];
  int _indiceColor = 0;

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

  // Determina si el texto debería ser oscuro basado en el color de fondo
  Color _getTextColor() {
    // Si el color es blanco, el texto será negro
    if (_colorActual == Colors.white) {
      return Colors.black;
    }
    // Para otros colores, el texto será blanco
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi App'),
      ),
      drawer: const SideMenu(),
      body: Center(
        child: Column(          
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: _colorActual,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: theme.colorScheme.primary.withAlpha(77),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(27),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                '¡Cambio de color!',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: _getTextColor(),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: _cambiarColor,
                      style: FilledButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                      ),
                      child: Text(
                        'Cambiar Color',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: _resetColor,
                      style: FilledButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondary,
                      ),
                      child: Text(
                        'Resetear Color',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}