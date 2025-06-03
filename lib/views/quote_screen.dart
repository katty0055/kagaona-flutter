import 'package:flutter/material.dart';
import 'package:kgaona/data/quote_repository.dart';
import 'package:kgaona/components/side_menu.dart';
import 'package:kgaona/domain/quote.dart';
import 'package:kgaona/constants/constantes.dart';
import 'package:intl/intl.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  QuoteScreenState createState() => QuoteScreenState();
}

class QuoteScreenState extends State<QuoteScreen> {
  final QuoteRepository _quoteService = QuoteRepository();
  final ScrollController _scrollController = ScrollController();

  List<Quote> _quotes = [];
  int _pageNumber = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadInitialQuotes();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent && !_isLoading && _hasMore) {
        _loadQuotes();
      }
    });
  }

  Future<void> _loadInitialQuotes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final allQuotes = await _quoteService.getAllQuotes();
      setState(() {
        _quotes = allQuotes;
        _pageNumber = 1;
        _hasMore = allQuotes.isNotEmpty;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(CotizacionConstantes.errorMessage)),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadQuotes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final newQuotes = await _quoteService.getPaginatedQuotes(pageNumber: _pageNumber, pageSize: 5);
      setState(() {
        _quotes.addAll(newQuotes);
        _pageNumber++;
        _hasMore = newQuotes.isNotEmpty;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(CotizacionConstantes.errorMessage)),
        );
      }     
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          CotizacionConstantes.titleApp,
          style: theme.textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      drawer: const SideMenu(),
      backgroundColor: theme.colorScheme.surface,
      body: RefreshIndicator(
        onRefresh: _loadInitialQuotes,
        child: _quotes.isEmpty && _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: theme.colorScheme.primary),
                    const SizedBox(height: 16),
                    Text(
                      CotizacionConstantes.loadingMessage,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              )
            : _quotes.isEmpty
                ? Center(
                    child: Text(
                      'No hay cotizaciones disponibles',
                      style: theme.textTheme.bodyLarge,
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _quotes.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _quotes.length) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: CircularProgressIndicator(color: theme.colorScheme.primary),
                          ),
                        );
                      }

                      final quote = _quotes[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: theme.dividerColor),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        quote.companyName,
                                        style: theme.textTheme.titleLarge,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: quote.changePercentage >= 0 
                                            ? Colors.green.withAlpha(27) 
                                            : Colors.red.withAlpha(27),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        '${quote.changePercentage >= 0 ? '+' : ''}${quote.changePercentage.toStringAsFixed(2)}%',
                                        style: theme.textTheme.labelMedium?.copyWith(
                                          color: quote.changePercentage >= 0 ? Colors.green : Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12.0),
                                Divider(color: theme.dividerColor),
                                const SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Precio actual',
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: theme.colorScheme.onSurface.withAlpha(154),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '\$${quote.stockPrice.toStringAsFixed(2)}',
                                          style: theme.textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Última actualización',
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: theme.colorScheme.onSurface.withAlpha(154),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _formatDate(quote.lastUpdated),
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat(AppConstantes.formatoFecha).format(date);
  }
}