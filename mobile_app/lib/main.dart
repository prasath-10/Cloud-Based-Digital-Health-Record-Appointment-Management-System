import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';

void main() {
  runApp(
    // ProviderScope stores the state of all Riverpod providers
    const ProviderScope(
      child: MigrantHealthApp(),
    ),
  );
}

class MigrantHealthApp extends StatelessWidget {
  const MigrantHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Migrant Worker Health Hub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
