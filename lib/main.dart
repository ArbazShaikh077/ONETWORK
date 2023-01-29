import 'package:flutter/material.dart';
import 'package:flutter_news_app/config/hive_constants.dart';
import 'package:flutter_news_app/dependency_injection.dart';
import 'package:flutter_news_app/onetwork.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  /// For ensuring all the dependecy in initialize before app gets started
  WidgetsFlutterBinding.ensureInitialized();

  /// For initializing the [ScreenUtil] plugin for giving the adaptive screen and font size
  await ScreenUtil.ensureScreenSize();

  /// For initializing the [fLutter_hive] plugin for local and secure storage solution
  await Hive.initFlutter();

  ///Opening the settings box first to check whether app is in dark mode or light mode
  await Hive.openBox(HiveConstants.settings);

  ///For initializing the dependency of the app
  await DependencyInjector.init();

  ///Main line for executing the flutter application
  runApp(const OneNetwork());
}
