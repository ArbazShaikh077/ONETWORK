import 'package:flutter/material.dart';
import 'package:flutter_news_app/dependency_injection.dart';
import 'package:flutter_news_app/onetwork.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await DependencyInjector.init();
  runApp(const OneNetwork());
}
