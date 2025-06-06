import 'package:kgaona/constants/constantes.dart';
import 'package:kgaona/api/service/quote_service.dart';
import 'package:kgaona/domain/quote.dart';

class QuoteRepository {
  final QuoteService _quoteService = QuoteService();

  Future<List<Quote>> getAllQuotes() {
    return _quoteService.fetchAllQuotes();
  }

  Future<Quote> getRandomQuote() {
    return _quoteService.fetchRandomQuote();
  }

  Future<List<Quote>> getPaginatedQuotes({
    required int pageNumber,
    int pageSize = CotizacionConstantes.pageSize,
  }) async {
    if (pageNumber < 1) {
      throw Exception(CotizacionConstantes.errorPageNumber);
    }
    if (pageSize <= 0) {
      throw Exception(CotizacionConstantes.errorPageSize);
    }
    final quotes = await _quoteService.getPaginatedQuotes(
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
    for (final quote in quotes) {
      if (quote.changePercentage > 100 || quote.changePercentage < -100) {
        throw Exception(CotizacionConstantes.errorPorcentaje);
      }
    }
    final filteredQuotes =
        quotes.where((quote) => quote.stockPrice > 0).toList();
    filteredQuotes.sort((a, b) => b.stockPrice.compareTo(a.stockPrice));
    await Future.delayed(const Duration(seconds: 2));
    return filteredQuotes;
  }
}
