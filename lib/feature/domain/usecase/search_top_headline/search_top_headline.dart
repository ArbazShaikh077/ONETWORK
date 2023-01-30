import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_news_app/core/use_case/use_case.dart';
import 'package:flutter_news_app/feature/data/model/response_model/top_headline_response_model.dart';
import 'package:flutter_news_app/feature/domain/repository/news/news_repository.dart';

class SearchTopHeadlinesNews
    implements UseCase<TopHeadlineResponseModel, ParamsSearchTopHeadlinesNews> {
  final NewsRepository newsRepository;

  SearchTopHeadlinesNews({required this.newsRepository});

  @override
  Future<Either<Failure, TopHeadlineResponseModel>> call(
      ParamsSearchTopHeadlinesNews params) async {
    return await newsRepository.searchTopHeadlinesNews(params.keyword);
  }
}

class ParamsSearchTopHeadlinesNews extends Equatable {
  final String keyword;

  const ParamsSearchTopHeadlinesNews({required this.keyword});

  @override
  List<Object> get props => [keyword];

  @override
  String toString() {
    return 'ParamsSearchTopHeadlinesNews{keyword: $keyword}';
  }
}
