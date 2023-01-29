import 'package:dio/dio.dart';
import 'package:flutter_news_app/feature/data/model/response_model/top_headline_response_model.dart';
import 'package:flutter_news_app/secreat.dart';

abstract class NewsRemoteDataSource {
  /// Calls the [baseUrl]/v2/top-headlines?category=:category&country=:country&apiKey=:apiKey endpoint
  ///
  /// Throws a [DioError] for all error codes.
  Future<TopHeadlineResponseModel> getTopHeadlinesNews(String category);

  /// Calls the [baseUrl]/v2/top-headlines?country=:country&apiKey=:apiKey&q=:q
  ///
  /// Throws a [DioError] for all error codes.
  Future<TopHeadlineResponseModel> searchTopHeadlinesNews(String keyword);
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final Dio dio;

  NewsRemoteDataSourceImpl({
    required this.dio,
  });

  @override
  Future<TopHeadlineResponseModel> getTopHeadlinesNews(String category) async {
    Response response;
    if (category == 'all') {
      response = await dio.get(
        '/v2/top-headlines',
        queryParameters: {
          'country': 'in',
          'apiKey': AuthToken.authToken,
        },
      );
    } else {
      response = await dio.get(
        '/v2/top-headlines',
        queryParameters: {
          'country': 'in',
          'apiKey': AuthToken.authToken,
          'category': category,
        },
      );
    }
    if (response.statusCode == 200) {
      return TopHeadlineResponseModel.fromJson(response.data);
    } else {
      throw DioError(
          requestOptions: RequestOptions(
        path: '/v2/top-headlines',
        queryParameters: {
          'country': 'in',
          'apiKey': AuthToken.authToken,
          'category': category,
        },
      ));
    }
  }

  @override
  Future<TopHeadlineResponseModel> searchTopHeadlinesNews(
      String keyword) async {
    var response = await dio.get(
      '/v2/top-headlines',
      queryParameters: {
        'country': 'in',
        'apiKey': AuthToken.authToken,
        'q': keyword,
      },
    );
    if (response.statusCode == 200) {
      return TopHeadlineResponseModel.fromJson(response.data);
    } else {
      throw DioError(
          requestOptions: RequestOptions(
        path: '/v2/top-headlines',
        queryParameters: {
          'country': 'in',
          'apiKey': AuthToken.authToken,
          'q': keyword,
        },
      ));
    }
  }
}
