import 'package:flutter/material.dart';
import 'screens/dashboard_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const AdaTamuApp());
}

class AdaTamuApp extends StatelessWidget {
  const AdaTamuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AdaTamu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: AppTextStyles.fontFamily,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.gradientEnd),
      ),
      home: const DashboardPage(),
    );
  }
}
