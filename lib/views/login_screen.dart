import 'package:flutter/material.dart';
import 'package:kgaona/components/snackbar_component.dart';
import 'package:kgaona/data/auth_repository.dart';
import 'package:kgaona/exceptions/api_exception.dart';
import 'package:kgaona/views/welcome_screen.dart';
import 'package:watch_it/watch_it.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final AuthRepository authRepository = di<AuthRepository>();
    
    return Scaffold(
      // appBar: AppBar(title: const Text('Inicio de Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                  'Inicio de Sesión',
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Usuario *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El correo es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña *',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La contraseña es obligatoria';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final username = usernameController.text.trim();
                    final password = passwordController.text.trim();

                    // Muestra un indicador de carga mientras se realiza la autenticación
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Center(child: CircularProgressIndicator());
                      },
                    );                    try {
                      await authRepository.login(
                        username,
                        password,
                      );

                      if (!context.mounted) return; // Verifica si el widget sigue montado antes de usar el contexto
                      Navigator.pop(context); // Cierra el indicador de carga

                      // Si llegamos aquí, el login fue exitoso
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WelcomeScreen(),
                        ),
                      );
                    } catch (e) {
                      if (!context.mounted) return; // Verifica si el widget sigue montado
                      Navigator.pop(context); // Cierra el indicador de carga
                      
                      // Usar SnackBarHelper para mostrar errores de forma consistente
                      if (e is ApiException && e.statusCode == 503) {
                        // Error de conectividad
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBarComponent.crear(
                            mensaje: 'Por favor, verifica tu conexión a internet.',
                            color: Colors.red,
                            duracion: const Duration(seconds: 4),
                          ),
                        );
                      } else {
                        // Otros errores
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBarComponent.crear(
                            mensaje: 'Inicio de sesión fallido',
                            color: Colors.red,
                            duracion: const Duration(seconds: 4),
                          ),
                        );
                      }
                    }
                  }
                },
                child: const Text('Iniciar Sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
