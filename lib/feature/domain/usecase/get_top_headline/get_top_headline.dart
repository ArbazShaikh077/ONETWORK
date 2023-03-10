import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_news_app/core/use_case/use_case.dart';
import 'package:flutter_news_app/feature/data/model/response_model/top_headline_response_model.dart';
import 'package:flutter_news_app/feature/domain/repository/news/news_repository.dart';

class GetTopHeadlinesNews
    implements UseCase<TopHeadlineResponseModel, ParamsGetTopHeadlinesNews> {
  final NewsRepository newsRepository;

  GetTopHeadlinesNews({required this.newsRepository});

  @override
  Future<Either<Failure, TopHeadlineResponseModel>> call(
      ParamsGetTopHeadlinesNews params) async {
    return await newsRepository.getTopHeadlinesNews(params.category);
  }
}

class ParamsGetTopHeadlinesNews extends Equatable {
  final String category;

  const ParamsGetTopHeadlinesNews({required this.category});

  @override
  List<Object> get props => [category];

  @override
  String toString() {
    return 'ParamsGetTopHeadlinesNews{category: $category}';
  }
}
