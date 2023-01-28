import 'package:flutter_news_app/config/hive_constants.dart';
import 'package:get_it/get_it.dart';

class DependencyInjector {
  static GetIt serviceLocator = GetIt.instance;

  static Future<void> init() async {
    /// [TODO] Initialize the service here for use in app

    /// For getting the hive key constants
    serviceLocator.registerLazySingleton(() => HiveConstants());
  }
}
