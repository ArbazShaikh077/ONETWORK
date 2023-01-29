import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/config/app_constants.dart';
import 'package:flutter_news_app/config/hive_constants.dart';
import 'package:flutter_news_app/feature/presentation/pages/home/home_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OneNetwork extends StatelessWidget {
  const OneNetwork({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) => ValueListenableBuilder(
        valueListenable: Hive.box(HiveConstants.settings).listenable(),
        builder: (context, box, widget) {
          var isDarkMode = box.get(HiveConstants.darkMode) ?? false;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppConstants.appName,
            theme: ThemeData(
              // colorScheme: lightColorScheme ??
              //     ColorScheme.fromSwatch(primarySwatch: Colors.blue),
              colorSchemeSeed: Colors.blue,
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: darkColorScheme ??
                  ColorScheme.fromSwatch(
                      primarySwatch: Colors.blue, brightness: Brightness.dark),
              useMaterial3: true,
            ),
            themeMode: ThemeMode.light,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
