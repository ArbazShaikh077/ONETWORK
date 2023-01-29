import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_news_app/feature/domain/usecase/get_top_headline/get_top_headline.dart';
import 'package:flutter_news_app/feature/presentation/bloc/top_headline_event.dart';
import 'package:flutter_news_app/feature/presentation/bloc/top_headline_state.dart';

class TopHeadlinesNewsBloc extends Bloc<TopHeadlinesEvent, TopHeadlinesState> {
  final GetTopHeadlinesNews getTopHeadlinesNews;
  // final SearchTopHeadlinesNews searchTopHeadlinesNews;

  TopHeadlinesNewsBloc({
    required this.getTopHeadlinesNews,
    // required this.searchTopHeadlinesNews,
  })  : assert(getTopHeadlinesNews != null),
        // assert(searchTopHeadlinesNews != null),
        super(InitialHeadlineState()) {
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
  }

  // Stream<TopHeadlinesState> mapEventToState(
  //   TopHeadlinesEvent event,
  // ) async* {
  //   if (event is LoadHeadLineEvent) {
  //     yield* _mapLoadTopHeadlinesNewsEventToState(event);
  //   }
  //   // else if (event is ChangeCategoryEvent) {
  //   //   yield* _mapChangeCategoryTopHeadlinesNewsEventToState(event);
  //   // } else if (event is SearchHeadlineEvent) {
  //   //   yield* _mapSearchTopHeadlinesNewsEventToState(event);
  //   // }
  // }

  // Stream<TopHeadlinesState> _mapLoadTopHeadlinesNewsEventToState(
  //     LoadHeadLineEvent event) async* {
  //   yield LoadingHeadlineState();
  //   var response = await getTopHeadlinesNews(
  //       ParamsGetTopHeadlinesNews(category: event.category));
  //   yield response.fold(
  //     // ignore: missing_return
  //     (failure) {
  //       if (failure is ServerFailure) {
  //         return FailureHeadlineState(errorMessage: failure.errorMessage);
  //       } else if (failure is ConnectionFailure) {
  //         return FailureHeadlineState(errorMessage: failure.errorMessage);
  //       } else {
  //         return const FailureHeadlineState(
  //             errorMessage: "Something went wrong");
  //       }
  //     },
  //     (data) => LoadedHeadlineState(listArticles: data.articles ?? []),
  //   );
  // }

  // Stream<TopHeadlinesNewsState> _mapChangeCategoryTopHeadlinesNewsEventToState(
  //   ChangeCategoryTopHeadlinesNewsEvent event,
  // ) async* {
  //   yield ChangedCategoryTopHeadlinesNewsState(
  //       indexCategorySelected: event.indexCategorySelected);
  // }

  // Stream<TopHeadlinesNewsState> _mapSearchTopHeadlinesNewsEventToState(
  //     SearchTopHeadlinesNewsEvent event) async* {
  //   yield LoadingTopHeadlinesNewsState();
  //   var result = await searchTopHeadlinesNews(
  //       ParamsSearchTopHeadlinesNews(keyword: event.keyword));
  //   yield result.fold(
  //     // ignore: missing_return
  //     (failure) {
  //       if (failure is ServerFailure) {
  //         return FailureTopHeadlinesNewsState(
  //             errorMessage: failure.errorMessage);
  //       } else if (failure is ConnectionFailure) {
  //         return FailureTopHeadlinesNewsState(
  //             errorMessage: failure.errorMessage);
  //       }
  //     },
  //     (response) =>
  //         SearchSuccessTopHeadlinesNewsState(listArticles: response.articles),
  //   );
  // }
}
