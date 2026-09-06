import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'data/services/local_cache_service.dart';
import 'firebase_options.dart';
import 'l10n/generated/app_localizations.dart';
import 'providers/locale_provider.dart';
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Hive offline cache
  await LocalCacheService.init();

  runApp(
    // ProviderScope stores the state of all Riverpod providers
    const ProviderScope(
      child: MigrantHealthApp(),
    ),
  );
}

class MigrantHealthApp extends ConsumerWidget {
  const MigrantHealthApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeNotifierProvider);

    return MaterialApp.router(
      title: 'Migrant Worker Health Hub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
      locale: currentLocale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
