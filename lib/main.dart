import 'dart:io';

import 'package:fitness_app/providers/isar_service.dart';
import 'package:fitness_app/providers/navigation_provider.dart';
import "package:fitness_app/providers/plan_provider.dart";
import 'package:fitness_app/providers/statistics_provider.dart';
import 'package:fitness_app/providers/theme_provider.dart';
import 'package:fitness_app/providers/workout_provider.dart';
import 'package:fitness_app/screens/main_scaffold.dart';
import 'package:fitness_app/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:path_provider_linux/path_provider_linux.dart';
import 'package:path_provider_windows/path_provider_windows.dart';
import 'package:provider/provider.dart';

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
  await isarService.clearDatabase();
  await isarService.seedDefaultExercises();
  await isarService.seedDefaultPlanA();
  await isarService.seedDefaultPlanB();
  await isarService.seedTestWeightLog();

  runApp(
    MultiProvider(
      providers: [
        Provider<IsarService>.value(value: isarService),
        ChangeNotifierProvider(
          create: (context) => PlanProvider(context.read<IsarService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => WorkoutProvider(
            context.read<IsarService>(),
            context.read<PlanProvider>(),
          ),
        ),
        ChangeNotifierProvider<ThemeProvider>.value(value: ThemeProvider()),
        ChangeNotifierProvider<NavigationProvider>.value(
          value: NavigationProvider(),
        ),
        ChangeNotifierProvider<StatisticsProvider>.value(
          value: StatisticsProvider(isarService),
        ),
      ],
      child: MainApp(),
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
    );
  }
}
