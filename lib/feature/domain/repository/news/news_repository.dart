import 'package:dartz/dartz.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_news_app/feature/data/model/response_model/top_headline_response_model.dart';

abstract class NewsRepository {
  Future<Either<Failure, TopHeadlineResponseModel>> getTopHeadlinesNews(
      String category);

  Future<Either<Failure, TopHeadlineResponseModel>> searchTopHeadlinesNews(
      String keyword);
}
