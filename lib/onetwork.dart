import 'package:flutter/material.dart';
import 'package:flutter_news_app/config/hive_constants.dart';
import 'package:flutter_news_app/feature/presentation/pages/home/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OneNetwork extends StatelessWidget {
  const OneNetwork({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(HiveConstants.settings).listenable(),
      builder: (context, box, widget) {
        var isDarkMode = box.get(HiveConstants.darkMode) ?? false;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Onetwork',
          theme: ThemeData(
            brightness: isDarkMode ? Brightness.dark : Brightness.light,
          ),
          home: HomePage(),
        );
      },
    );
  }
}
