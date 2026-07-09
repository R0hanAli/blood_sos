import 'package:blood_sos/core/config/router.dart';
import 'package:blood_sos/core/services/providers.dart';
import 'package:blood_sos/core/services/storage_service.dart';
import 'package:blood_sos/core/theme/app_theme.dart';
import 'package:blood_sos/core/theme/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully on client.');
  } catch (e) {
    debugPrint(
      '================================================================',
    );
    debugPrint(
      'Firebase client failed to initialize. Please check your google-services.json',
    );
    debugPrint(
      'or GoogleService-Info.plist configurations. App will run in fallback.',
    );
    debugPrint('Error details: $e');
  }

  final storageService = await StorageService.init();

  runApp(
    ProviderScope(
      overrides: [storageServiceProvider.overrideWithValue(storageService)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'BloodSOS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
