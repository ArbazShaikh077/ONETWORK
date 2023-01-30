import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_news_app/feature/domain/usecase/get_top_headline/get_top_headline.dart';
import 'package:flutter_news_app/feature/domain/usecase/search_top_headline/search_top_headline.dart';
import 'package:flutter_news_app/feature/presentation/bloc/top_headline_event.dart';
import 'package:flutter_news_app/feature/presentation/bloc/top_headline_state.dart';

class TopHeadlinesNewsBloc extends Bloc<TopHeadlinesEvent, TopHeadlinesState> {
  final GetTopHeadlinesNews getTopHeadlinesNews;
  final SearchTopHeadlinesNews searchTopHeadlinesNews;

  TopHeadlinesNewsBloc({
    required this.getTopHeadlinesNews,
    required this.searchTopHeadlinesNews,
  }) : super(InitialHeadlineState()) {
    on<LoadHeadLineEvent>((event, emit) async {
      emit(LoadingHeadlineState());
      var response = await getTopHeadlinesNews(
          ParamsGetTopHeadlinesNews(category: event.category));
      emit(response.fold(
        // ignore: missing_return
        (failure) {
          if (failure is ServerFailure) {
            return FailureHeadlineState(errorMessage: failure.errorMessage);
          } else if (failure is ConnectionFailure) {
            return FailureHeadlineState(errorMessage: failure.errorMessage);
          } else {
            return const FailureHeadlineState(
                errorMessage: "Something went wrong");
          }
        },
        (data) => LoadedHeadlineState(listArticles: data.articles ?? []),
      ));
    });
    on<ChangeCategoryEvent>((event, emit) {
      emit(ChangeCategoryHeadlineState(
          indexCategorySelected: event.indexCategorySelected));
    });

    on<SearchHeadlineEvent>((event, emit) async {
      emit(LoadingHeadlineState());
      var result = await searchTopHeadlinesNews(
          ParamsSearchTopHeadlinesNews(keyword: event.keyword));
      emit(result.fold(
        // ignore: missing_return
        (failure) {
          if (failure is ServerFailure) {
            return FailureHeadlineState(errorMessage: failure.errorMessage);
          } else if (failure is ConnectionFailure) {
            return FailureHeadlineState(errorMessage: failure.errorMessage);
          } else {
            return const FailureHeadlineState(
                errorMessage: "Something went wrong");
          }
        },
        (response) =>
            SearchedHeadlineState(listArticles: response.articles ?? []),
      ));
    });
  }
}
