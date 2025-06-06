import 'package:flutter/material.dart';
import 'package:kgaona/components/side_menu.dart';
import 'package:kgaona/constants/constantes.dart';
import 'package:kgaona/theme/colors.dart';

class MiAppScreen extends StatefulWidget {
  const MiAppScreen({super.key});

  @override
  MiAppScreenState createState() => MiAppScreenState();
}

class MiAppScreenState extends State<MiAppScreen> {
  Color _colorActual = AppColors.primaryDarkBlue;
  final List<Color> _colores = [
    AppColors.primaryDarkBlue,
    AppColors.error,
    AppColors.success,
  ];
  int _indiceColor = 0;

  void _cambiarColor() {
    setState(() {
      _indiceColor = (_indiceColor + 1) % _colores.length;
      _colorActual = _colores[_indiceColor];
    });
  }

  void _resetColor() {
    setState(() {
      _colorActual = Colors.white;
    });
  }

  Color _getTextColor() {
    if (_colorActual == Colors.white) {
      return Colors.black;
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text(AppConstantes.titleMyApp)),
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
                AppConstantes.cambioColor,
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
                        AppConstantes.cambiarColor,
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
                        AppConstantes.resetColor,
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
