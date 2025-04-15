import 'dart:async';
import 'dart:math';
import 'package:kgaona/domain/quote.dart';

class QuoteRepository {
  final List<Quote> _quotes = [
    Quote(companyName: 'Apple', stockPrice: 150.25, changePercentage: 2.5, lastUpdated: DateTime.now(),),
    Quote(companyName: 'Microsoft', stockPrice: 280.50, changePercentage: -1.2, lastUpdated: DateTime.now(),),
    Quote(companyName: 'Google', stockPrice: 2700.00, changePercentage: 0.8, lastUpdated: DateTime.now(),),
    Quote(companyName: 'Amazon', stockPrice: 3400.75, changePercentage: -0.5, lastUpdated: DateTime.now(),),
    Quote(companyName: 'Tesla', stockPrice: 700.10, changePercentage: 3.0, lastUpdated: DateTime.now(),),
  ];

  // Método para obtener todas las cotizaciones
  Future<List<Quote>> fetchAllQuotes() async {
    await Future.delayed(const Duration(seconds: 2)); // Simula un delay de 2 segundos
    return _quotes;
  }

  // Método para obtener una cotización aleatoria
  Future<Quote> fetchRandomQuote() async {
    await Future.delayed(const Duration(seconds: 1)); // Simula un delay de 1 segundo
    final randomIndex = Random().nextInt(_quotes.length); // Genera un índice aleatorio
    return _quotes[randomIndex];
  }
}