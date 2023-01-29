import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_news_app/config/hive_constants.dart';
import 'package:flutter_news_app/feature/data/datasource/news_remote_data_source.dart';
import 'package:flutter_news_app/feature/data/repository/news_repository.dart';
import 'package:flutter_news_app/feature/domain/usecase/get_top_headline/get_top_headline.dart';
import 'package:flutter_news_app/feature/presentation/bloc/top_headline_bloc.dart';
import 'package:get_it/get_it.dart';

import 'core/network/network_info.dart';
import 'feature/domain/repository/news/news_repository.dart';

class DependencyInjector {
  static GetIt serviceLocator = GetIt.instance;

  static Future<void> init() async {
    /// [TODO] Initialize the service here for use in app

    /// Inject application BLoC
    serviceLocator.registerFactory(
      () => TopHeadlinesNewsBloc(
        getTopHeadlinesNews: serviceLocator(),
        // searchTopHeadlinesNews: serviceLocator(),
      ),
    );

    /// Inject the usecases
    serviceLocator.registerLazySingleton(
        () => GetTopHeadlinesNews(newsRepository: serviceLocator()));

    /// Inject the networkinfo class for handling all network information
    serviceLocator.registerLazySingleton<NewsRepository>(() =>
        NewsRepositoryImpl(
            newsRemoteDataSource: serviceLocator(),
            networkInfo: serviceLocator()));

    /// For getting the response from server
    serviceLocator.registerLazySingleton<NewsRemoteDataSource>(
        () => NewsRemoteDataSourceImpl(
              dio: serviceLocator(),
            ));

    /// For getting current network information
    serviceLocator.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImpl(serviceLocator()));

    serviceLocator.registerLazySingleton(() {
      final dio = Dio();
      dio.options.baseUrl = "https://newsapi.org";
      // dio.interceptors.add(DioLoggingInterceptor());
      return dio;
    });

    /// For getting the hive key constants
    serviceLocator.registerLazySingleton(() => HiveConstants());

    /// For checking the internet connection
    serviceLocator.registerLazySingleton(() => Connectivity());
  }
}
