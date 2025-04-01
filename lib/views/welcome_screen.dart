import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
    const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  List<String> quotes = [];
  bool isLoading = false;

  Future<void> fetchQuotes() async {
    setState(() {
      isLoading = true;
    });

    // Simulación de una llamada a una API o base de datos
    await Future.delayed(const Duration(seconds: 2)); // Simula un retraso
    setState(() {
      quotes = [
        'Cotización 1: 100',
        'Cotización 2: 200',
        'Cotización 3: 300',
        'Cotización 4: 400',
      ];
      isLoading = false;
    });
    
  }
   _mostrarCotizaciones() {
    print("Cotizacion");

}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bienvenido')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¡Bienvenido!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Has iniciado sesión exitosamente.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Acción para listar cotizaciones
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Listando cotizaciones...'),
                  ),
                );
              },
              child: const Text('Listar Cotizaciones PS'),
            ),
            ElevatedButton(
              onPressed: fetchQuotes,
              child: const Text('Listar Cotizaciones'),
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const CircularProgressIndicator()
            else
              ...quotes.map((quote) => Text(quote)).toList(),
            ElevatedButton(
              onPressed: _mostrarCotizaciones,
              child: Text("Cotizaciones"),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes agregar la lógica para listar cotizaciones
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Listando cotizaciones...')),
                );
              },
              child: const Text('Listar Cotizaciones'),
            ),
          ],
        ),
      ),
    );
  }
}
