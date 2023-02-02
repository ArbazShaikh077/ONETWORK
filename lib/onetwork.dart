import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/config/app_constants.dart';
import 'package:flutter_news_app/config/hive_constants.dart';
import 'package:flutter_news_app/feature/presentation/pages/home/home_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.danger,
  });

  final Color? danger;

  @override
  CustomColors copyWith({Color? danger}) {
    return CustomColors(
      danger: danger ?? this.danger,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      danger: Color.lerp(danger, other.danger, t),
    );
  }

  CustomColors harmonized(ColorScheme dynamic) {
    return copyWith(danger: danger!.harmonizeWith(dynamic.primary));
  }
}

class OneNetwork extends StatelessWidget {
  OneNetwork({super.key});
// Fictitious brand color.
  final _brandBlue = const Color(0xFF1E88E5);

  CustomColors lightCustomColors = const CustomColors(danger: Colors.green);
  CustomColors darkCustomColors = const CustomColors(danger: Color(0xFFEF9A9A));
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      ColorScheme lightColorScheme;
      ColorScheme darkColorScheme;

      if (lightDynamic != null && darkDynamic != null) {
        // On Android S+ devices, use the provided dynamic color scheme.
        // (Recommended) Harmonize the dynamic color scheme' built-in semantic colors.
        lightColorScheme = lightDynamic.harmonized();
        // (Optional) Customize the scheme as desired. For example, one might
        // want to use a brand color to override the dynamic [ColorScheme.secondary].
        lightColorScheme = lightColorScheme.copyWith(secondary: _brandBlue);
        // (Optional) If applicable, harmonize custom colors.
        lightCustomColors = lightCustomColors.harmonized(lightColorScheme);

        // Repeat for the dark color scheme.
        darkColorScheme = darkDynamic.harmonized();
        darkColorScheme = darkColorScheme.copyWith(secondary: _brandBlue);
        darkCustomColors = darkCustomColors.harmonized(darkColorScheme);
      } else {
        // Otherwise, use fallback schemes.
        lightColorScheme = ColorScheme.fromSeed(
          seedColor: _brandBlue,
        );
        darkColorScheme = ColorScheme.fromSeed(
          seedColor: _brandBlue,
          brightness: Brightness.dark,
        );
      }

      return ValueListenableBuilder(
        valueListenable: Hive.box(HiveConstants.settings).listenable(),
        builder: (context, box, widget) {
          var isDarkMode = box.get(HiveConstants.darkMode) ?? false;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppConstants.appName,
            theme: ThemeData(
              colorScheme: lightColorScheme,
              extensions: [lightCustomColors],
            ),
            darkTheme: ThemeData(
              colorScheme: darkColorScheme,
              extensions: [darkCustomColors],
            ),
            themeMode: ThemeMode.light,
            home: const HomePage(),
          );
        },
      );
    });
  }
}
