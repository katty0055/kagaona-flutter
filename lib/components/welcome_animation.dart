import 'package:flutter/material.dart';
import 'package:kgaona/theme/colors.dart';

/// Widget de animación para la pantalla de bienvenida
class WelcomeAnimation extends StatefulWidget {
  final String username;
  
  const WelcomeAnimation({
    super.key, 
    required this.username,
  });

  @override
  State<WelcomeAnimation> createState() => _WelcomeAnimationState();
}

class _WelcomeAnimationState extends State<WelcomeAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation; // Cambiamos a rotación completa
  
  @override
  void initState() {
    super.initState();
    
    // Controlador para todas las animaciones
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    
    // Animación para aparecer gradualmente
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );
    
    // Animación para escalar
    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );
    
    // Animación para la rotación del icono
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * 3.14159).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
      ),
    );
    
    // Iniciar animación una vez
    _controller.forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono animado
            Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _fadeInAnimation.value,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withAlpha(40),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Center(
                    // Usamos la animación de rotación
                    child: Transform.rotate(
                      angle: _rotationAnimation.value,
                      child: const WelcomeIcon(),
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Texto de bienvenida animado
            FadeTransition(
              opacity: Animation<double>.fromValueListenable(
                _fadeInAnimation, 
                transformer: (value) => Tween<double>(begin: 0.0, end: 1.0)
                  .animate(CurvedAnimation(
                    parent: _controller,
                    curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
                  ))
                  .value,
              ),
              child: Column(
                children: [
                  Text(
                    '¡Hola!',
                    style: theme.textTheme.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.username,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Ícono personalizado para la pantalla de bienvenida
class WelcomeIcon extends StatelessWidget {
  const WelcomeIcon({super.key});
  
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WelcomeIconPainter(),
      size: const Size(80, 80),
    );
  }
}

/// CustomPainter para dibujar un icono de bienvenida
class WelcomeIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    
    // Color primario para el icono (azul como el AppBar)
    final Paint primaryPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          AppColors.primaryDarkBlue,
          AppColors.primaryLightBlue,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.fill;

    // Color para detalles del icono
    final Paint detailPaint = Paint()
      ..color = AppColors.primaryDarkBlue.withAlpha(178)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width * 0.03
      ..strokeCap = StrokeCap.round;
    
    // Centro del canvas
    final centerX = width / 2;
    final centerY = height / 2;
    
    // Dibuja un círculo de saludo/bienvenida
    final radius = width * 0.55;
    
    // Añadir un resplandor sutil al círculo interior
    canvas.drawCircle(
      Offset(centerX, centerY),
      radius * 1.1,
      Paint()
        ..color = AppColors.blue03.withAlpha(77)
        ..style = PaintingStyle.fill,
    );

    // Luego el círculo principal
    canvas.drawCircle(
      Offset(centerX, centerY),
      radius,
      primaryPaint,
    );
    
    // Dibuja una "V" o check dentro del círculo (símbolo de verificación/bienvenida)
    final checkPath = Path();
    checkPath.moveTo(width * 0.3, height * 0.5); // Punto inicial del check
    checkPath.lineTo(width * 0.45, height * 0.65); // Punto medio del check
    checkPath.lineTo(width * 0.7, height * 0.35); // Punto final del check
    
    canvas.drawPath(
      checkPath,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = width * 0.08
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    
    // Dibuja un borde circular alrededor del icono principal
    canvas.drawCircle(
      Offset(centerX, centerY),
      radius + width * 0.2,
      detailPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}