import 'package:equatable/equatable.dart';

abstract class TopHeadlinesEvent extends Equatable {
  const TopHeadlinesEvent();
}

class LoadHeadLineEvent extends TopHeadlinesEvent {
  final String category;

  const LoadHeadLineEvent({required this.category});

  @override
  List<Object> get props => [category];

  @override
  String toString() {
    return 'LoadTopHeadlinesNewsEvent{category: $category}';
  }
}

class ChangeCategoryEvent extends TopHeadlinesEvent {
  final int indexCategorySelected;

  const ChangeCategoryEvent({required this.indexCategorySelected});

  @override
  List<Object> get props => [indexCategorySelected];

  @override
  String toString() {
    return 'ChangeCategoryTopHeadlinesNewsEvent{indexCategorySelected: $indexCategorySelected}';
  }
}

class SearchHeadlineEvent extends TopHeadlinesEvent {
  final String keyword;

  const SearchHeadlineEvent({required this.keyword});

  @override
  List<Object> get props => [keyword];

  @override
  String toString() {
    return 'SearchTopHeadlinesNewsEvent{keyword: $keyword}';
  }
}
