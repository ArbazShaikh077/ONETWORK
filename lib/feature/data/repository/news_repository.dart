import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_news_app/core/network/network_info.dart';
import 'package:flutter_news_app/feature/data/datasource/news_remote_data_source.dart';
import 'package:flutter_news_app/feature/data/model/response_model/top_headline_response_model.dart';

import 'package:flutter_news_app/feature/domain/repository/news/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource newsRemoteDataSource;
  final NetworkInfo networkInfo;

  NewsRepositoryImpl({
    required this.newsRemoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, TopHeadlineResponseModel>> getTopHeadlinesNews(
      String category) async {
    var isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        var response = await newsRemoteDataSource.getTopHeadlinesNews(category);
        return Right(response);
      } on DioError catch (error) {
        return Left(ServerFailure(error.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, TopHeadlineResponseModel>> searchTopHeadlinesNews(
      String keyword) async {
    var isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        var response =
            await newsRemoteDataSource.searchTopHeadlinesNews(keyword);
        return Right(response);
      } on DioError catch (error) {
        return Left(ServerFailure(error.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
