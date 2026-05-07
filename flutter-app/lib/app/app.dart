import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'router.dart';

class AiTradingCopilotApp extends StatelessWidget {
  const AiTradingCopilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AI Trading Copilot',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: router,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: child!,
        );
      },
    );
  }
}
