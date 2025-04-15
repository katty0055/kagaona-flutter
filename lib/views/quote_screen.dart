import 'package:flutter/material.dart';
import 'package:kgaona/api/service/quote_service.dart';
import 'package:kgaona/domain/quote.dart';
import 'package:kgaona/constants.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  _QuoteScreenState createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  final QuoteService _quoteService = QuoteService();
  final ScrollController _scrollController = ScrollController();

  List<Quote> _quotes = [];
  int _pageNumber = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadQuotes();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent && !_isLoading && _hasMore) {
        _loadQuotes();
      }
    });
  }

  Future<void> _loadQuotes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final newQuotes = await _quoteService.getPaginatedQuotes(pageNumber: _pageNumber, pageSize: Constants.pageSize);
      setState(() {
        _quotes.addAll(newQuotes);
        _pageNumber++;
        _hasMore = newQuotes.isNotEmpty;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(Constants.errorMessage)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.titleApp),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: _quotes.isEmpty && _isLoading
          ? const Center(
              child: Text(Constants.loadingMessage),
            )
          : ListView.builder(
              controller: _scrollController,
              itemCount: _quotes.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _quotes.length) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final quote = _quotes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quote.companyName,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8.0),
                        Text('Precio: \$${quote.stockPrice.toStringAsFixed(2)}'),
                        Text(
                          'Cambio: ${quote.changePercentage.toStringAsFixed(2)}%',
                          style: TextStyle(
                            color: quote.changePercentage >= 0 ? Colors.green : Colors.red,
                          ),
                        ),
                        Text(
                          'Última actualización: ${_formatDate(quote.lastUpdated)}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}