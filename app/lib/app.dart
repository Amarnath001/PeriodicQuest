import 'package:flutter/material.dart';

import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'features/landing/presentation/landing_screen.dart';

class PeriodicQuestApp extends StatelessWidget {
  const PeriodicQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const LandingPage(),
    );
  }
}
