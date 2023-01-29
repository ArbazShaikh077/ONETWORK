import 'package:equatable/equatable.dart';
import 'package:flutter_news_app/feature/data/model/response_model/top_headline_response_model.dart';

abstract class TopHeadlinesState extends Equatable {
  const TopHeadlinesState();

  @override
  List<Object> get props => [];
}

class InitialHeadlineState extends TopHeadlinesState {}

class LoadingHeadlineState extends TopHeadlinesState {}

class LoadedHeadlineState extends TopHeadlinesState {
  final List<Article> listArticles;

  const LoadedHeadlineState({required this.listArticles});

  @override
  List<Object> get props => [listArticles];

  @override
  String toString() {
    return 'LoadedTopHeadlinesNewsState{listArticles: $listArticles}';
  }
}

class FailureHeadlineState extends TopHeadlinesState {
  final String errorMessage;

  const FailureHeadlineState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() {
    return 'FailureTopHeadlinesNewsState{errorMessage: $errorMessage}';
  }
}

class ChangeCategoryHeadlineState extends TopHeadlinesState {
  final int indexCategorySelected;

  const ChangeCategoryHeadlineState({required this.indexCategorySelected});

  @override
  List<Object> get props => [indexCategorySelected];

  @override
  String toString() {
    return 'ChangedCategoryTopHeadlinesNewsState{indexCategorySelected: $indexCategorySelected}';
  }
}

class SearchedHeadlineState extends TopHeadlinesState {
  final List<Article> listArticles;

  const SearchedHeadlineState({required this.listArticles});

  @override
  List<Object> get props => [listArticles];

  @override
  String toString() {
    return 'SearchSuccessTopHeadlinesNewsState{listArticles: $listArticles}';
  }
}
