import 'package:kgaona/data/quote_repository.dart';
import 'package:kgaona/domain/quote.dart';

class QuoteService {
  final QuoteRepository _repository = QuoteRepository();

  // Método para obtener todas las cotizaciones
  Future<List<Quote>> getAllQuotes() {
    return _repository.fetchAllQuotes();
  }

  // Método para obtener una cotización aleatoria
  Future<Quote> getRandomQuote() {
    return _repository.fetchRandomQuote();
  }
}