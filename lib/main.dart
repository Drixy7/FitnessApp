import 'dart:io';

import 'package:fitness_app/providers/body_weight_statistics_provider.dart';
import 'package:fitness_app/providers/isar_service.dart';
import 'package:fitness_app/providers/lifting_statistics_provider.dart';
import 'package:fitness_app/providers/navigation_provider.dart';
import "package:fitness_app/providers/plan_provider.dart";
import 'package:fitness_app/providers/theme_provider.dart';
import 'package:fitness_app/providers/workout_provider.dart';
import 'package:fitness_app/screens/main_scaffold.dart';
import 'package:fitness_app/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:path_provider_linux/path_provider_linux.dart';
import 'package:path_provider_windows/path_provider_windows.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows) {
    PathProviderWindows.registerWith();
  } else if (Platform.isLinux) {
    PathProviderLinux.registerWith();
  } else if (Platform.isAndroid) {
    PathProviderAndroid.registerWith();
  }

  final isarService = IsarService();

  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  if (isFirstLaunch) {
    await isarService.seedDefaultExercises();
    await isarService.seedDefaultPlanA();
    await isarService.seedDefaultPlanB();
    await isarService.seedDefaultPlanC();

    await prefs.setBool('isFirstLaunch', false);
    await prefs.setString("firstLaunchDate", DateTime.now().toString());
  }

  // ODSTRANĚNO PRO RELEASE:
  // await isarService.clearDatabase();
  // await isarService.seedTestWeightLog();

  runApp(
    MultiProvider(
      providers: [
        Provider<IsarService>(create: (_) => isarService),
        ChangeNotifierProvider<PlanProvider>(
          create: (context) => PlanProvider(context.read<IsarService>()),
        ),
        ChangeNotifierProvider<WorkoutProvider>(
          create: (context) => WorkoutProvider(
            context.read<IsarService>(),
            context.read<PlanProvider>(),
          ),
        ),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<NavigationProvider>(
          create: (_) => NavigationProvider(),
        ),
        ChangeNotifierProvider<BodyWeightStatisticsProvider>(
          create: (_) => BodyWeightStatisticsProvider(isarService),
        ),
        ChangeNotifierProvider<LiftingStatisticsProvider>(
          create: (_) => LiftingStatisticsProvider(isarService),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isPink = themeProvider.appStyle == AppStyle.pink;

    return MaterialApp(
      title: 'Fitness App',
      theme: isPink ? AppTheme.getPinkLight() : AppTheme.getBlueLight(),
      darkTheme: isPink ? AppTheme.getPinkDark() : AppTheme.getBlueDark(),
      themeMode: themeProvider.themeMode,
      home: const MainScaffold(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', 'US'), Locale('en', 'GB')],
    );
  }
}
