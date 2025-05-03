import 'package:equatable/equatable.dart';

abstract class PreferenciaEvent extends Equatable {
  const PreferenciaEvent();

  @override
  List<Object?> get props => [];
}

class LoadPreferences extends PreferenciaEvent {
  const LoadPreferences();
}

class ChangeCategory extends PreferenciaEvent {
  final String category;
  final bool selected;

  const ChangeCategory({
    required this.category,
    required this.selected,
  });

  @override
  List<Object> get props => [category, selected];
}

class ChangeFavoritesVisibility extends PreferenciaEvent {
  final bool showFavorites;

  const ChangeFavoritesVisibility({required this.showFavorites});

  @override
  List<Object> get props => [showFavorites];
}

class SearchByKeyword extends PreferenciaEvent {
  final String? keyword;

  const SearchByKeyword({this.keyword});

  @override
  List<Object?> get props => [keyword];
}

class FilterByDate extends PreferenciaEvent {
  final DateTime? fromDate;
  final DateTime? toDate;

  const FilterByDate({
    this.fromDate,
    this.toDate,
  });

  @override
  List<Object?> get props => [fromDate, toDate];
}

class ChangeSort extends PreferenciaEvent {
  final String sortBy;
  final bool ascending;

  const ChangeSort({
    required this.sortBy,
    required this.ascending,
  });

  @override
  List<Object> get props => [sortBy, ascending];
}

class ResetFilters extends PreferenciaEvent {
  const ResetFilters();
}

class SavePreferences extends PreferenciaEvent {
  final List<String> selectedCategories;

  const SavePreferences({
    required this.selectedCategories,
  });

  @override
  List<Object> get props => [selectedCategories];
}
