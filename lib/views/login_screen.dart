import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgaona/bloc/auth/auth_bloc.dart';
import 'package:kgaona/bloc/auth/auth_event.dart';
import 'package:kgaona/bloc/auth/auth_state.dart';
import 'package:kgaona/bloc/noticia/noticia_bloc.dart';
import 'package:kgaona/bloc/noticia/noticia_event.dart';
import 'package:kgaona/components/login_animation.dart';
import 'package:kgaona/components/responsive_container.dart';
import 'package:kgaona/constants/constantes.dart';
import 'package:kgaona/helpers/common_widgets_helper.dart';
import 'package:kgaona/helpers/snackbar_helper.dart';
import 'package:kgaona/views/welcome_screen.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final theme = Theme.of(context);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const Center(child: CircularProgressIndicator());
            },
          );
        } else if (state is AuthAuthenticated) {
          Navigator.of(
            context,
            rootNavigator: true,
          ).popUntil((route) => route.isFirst);
          context.read<NoticiaBloc>().add(FetchNoticiasEvent());
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          );
        } else if (state is AuthFailure) {
          Navigator.of(
            context,
            rootNavigator: true,
          ).popUntil((route) => route.isFirst);
          SnackBarHelper.mostrarError(context, mensaje: state.error.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: ResponsiveContainer(
            child: SingleChildScrollView(
              child: CommonWidgetsHelper.paddingContainer32(
                color: theme.colorScheme.surface,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const LoginAnimation(),
                      CommonWidgetsHelper.buildSpacing16(),
                      CommonWidgetsHelper.seccionSubTitulo(
                        title: AuthConstantes.appTitle,
                      ),
                      CommonWidgetsHelper.buildSpacing32(),
                      TextFormField(
                        controller: usernameController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AuthConstantes.usuarioObligatorio;
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: AuthConstantes.usuario,
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      CommonWidgetsHelper.buildSpacing16(),
                      TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AuthConstantes.contrasenaObligatoria;
                          }
                          return null;
                        },
                        obscureText: !state.passwordVisible,
                        decoration: InputDecoration(
                          labelText: AuthConstantes.contrasena,
                          prefixIcon: IconButton(
                            icon: Icon(
                              state.passwordVisible
                                  ? Icons.key_off_outlined
                                  : Icons.key_outlined,
                            ),
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                TogglePasswordVisibility(),
                              );
                            },
                            tooltip:
                                state.passwordVisible
                                    ? AuthConstantes.ocultarContrasena
                                    : AuthConstantes.mostrarContrasena,
                          ),
                        ),
                      ),
                      CommonWidgetsHelper.buildSpacing16(),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final username = usernameController.text.trim();
                              final password = passwordController.text.trim();
                              context.read<AuthBloc>().add(
                                AuthLoginRequested(
                                  email: username,
                                  password: password,
                                ),
                              );
                            }
                          },
                          child: const Text(AuthConstantes.iniciarSesion),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
