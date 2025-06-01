import 'package:flutter/material.dart';
import 'package:kgaona/theme/colors.dart';

/// Widget de animación para la pantalla de inicio de sesión con icono de usuario
class LoginAnimation extends StatefulWidget {
  const LoginAnimation({super.key});

  @override
  State<LoginAnimation> createState() => _LoginAnimationState();
}

class _LoginAnimationState extends State<LoginAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Configuración del controlador de animación
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true); // Con reverse para un efecto más suave
    
    // Animación de pulsación más pronunciada
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller, 
        curve: Curves.easeInOut,
      ),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Center(
          child: Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.gray01,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryDarkBlue.withAlpha(40),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const UserIconAnimated(),
            ),
          ),
        );
      },
    );
  }
}

/// Icono de usuario animado, más simple y similar a un icono estándar
class UserIconAnimated extends StatelessWidget {
  const UserIconAnimated({super.key});
  
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: UserIconPainter(),
      size: const Size(120, 120),
    );
  }
}

/// Painter para dibujar un icono de usuario estándar
class UserIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    
    // Color primario para el icono
    final Paint primaryPaint = Paint()
      ..color = AppColors.primaryDarkBlue
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.5;
    
    // Centro de la pantalla
    final centerX = width / 2;
    final centerY = height / 2;
    
    // Dibujar cabeza (círculo) - Parte superior del icono de usuario
    final headRadius = width * 0.2;
    canvas.drawCircle(
      Offset(centerX, centerY - height * 0.1), 
      headRadius, 
      primaryPaint
    );
    
    // Dibujar cuerpo (medio círculo/forma de usuario) - INVERTIDO
    final bodyPath = Path();
    
    // Crear la forma del cuerpo como un semicírculo orientado hacia arriba
    final bodyRect = Rect.fromCenter(
      center: Offset(centerX, centerY + height * 0.25),
      width: width * 0.6,
      height: height * 0.5,
    );
    
    // Cambiamos el ángulo inicial y sweep para invertir el arco
    bodyPath.addArc(
      bodyRect,
      3.14, // PI radianes = 180 grados (comienza desde abajo)
      3.14, // PI radianes = 180 grados (termina arriba)
    );
    
    // Cerrar el path para formar una figura completa (invertida)
    bodyPath.lineTo(centerX - width * 0.3, centerY + height * 0.25);
    bodyPath.lineTo(centerX + width * 0.3, centerY + height * 0.25);
    bodyPath.close();
    
    canvas.drawPath(bodyPath, primaryPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // Estático, no necesita repintarse por cambios en propiedades
  }
}