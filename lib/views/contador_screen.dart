import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgaona/bloc/contador/contador_bloc.dart';
import 'package:kgaona/bloc/contador/contador_event.dart';
import 'package:kgaona/bloc/contador/contador_state.dart';
import 'package:kgaona/components/side_menu.dart';

class ContadorScreen extends StatelessWidget {
  const ContadorScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ContadorBloc(),
      child: _ContadorView(title: title),
    );
  }
}

class _ContadorView extends StatelessWidget {
  const _ContadorView({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: const SideMenu(),
      body: BlocBuilder<ContadorBloc, ContadorState>(
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Has presionado el botón estas veces:',
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  '${state.valor}',
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: state.colorMensaje.withAlpha(27),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    state.mensaje,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: state.colorMensaje,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                if (state.status == ContadorStatus.loading)
                  CircularProgressIndicator(color: theme.colorScheme.primary),
                if (state.status == ContadorStatus.error)
                  Text(
                    state.errorMessage ?? 'Ha ocurrido un error',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              heroTag: 'decrement',
              backgroundColor: theme.colorScheme.primary,
              onPressed:
                  () => context.read<ContadorBloc>().add(
                    ContadorDecrementEvent(),
                  ),
              tooltip: 'Disminuir',
              child: Icon(Icons.remove, color: theme.colorScheme.onPrimary),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              heroTag: 'increment',
              backgroundColor: theme.colorScheme.primary,
              onPressed:
                  () => context.read<ContadorBloc>().add(
                    ContadorIncrementEvent(),
                  ),
              tooltip: 'Incrementar',
              child: Icon(Icons.add, color: theme.colorScheme.onPrimary),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              heroTag: 'reset',
              backgroundColor: theme.colorScheme.secondary,
              onPressed:
                  () => context.read<ContadorBloc>().add(ContadorResetEvent()),
              tooltip: 'Reiniciar',
              child: Icon(Icons.refresh, color: theme.colorScheme.onPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
