import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kowairo/core/routing/app_router.dart';
import 'package:kowairo/gen/colors.gen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    // IMPORTANT: Use environment variables for these, not hardcoded strings
    url: 'https://oizddrgiixauodoqwxwx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9pemRkcmdpaXhhdW9kb3F3eHd4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUwNTk1NDMsImV4cCI6MjA3MDYzNTU0M30.jA9fc1R0i0DgpRWgbDfw-9ObK8afAb4oM0CMrjdagks',
  );

  runApp(const ProviderScope(child: MyApp()));
}

// MyApp now needs to be a ConsumerWidget to access the router provider
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the goRouterProvider
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Kowairo',
      locale: const Locale('ja', 'JP'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ja', 'JP'), Locale('en', 'US')],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primaryBackground,
          centerTitle: true,
          titleTextStyle: TextStyle(color: AppColors.primaryText, fontSize: 22, fontWeight: FontWeight.w600),
        ),
        scaffoldBackgroundColor: Colors.white,
        primaryColor: AppColors.primaryText,
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: AppColors.primaryText, // Default text color for body
          displayColor: AppColors.primaryText, // Default text color for headlines
        ),
        dividerColor: AppColors.borderColor,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: AppColors.borderColor),
          ),
        ),
      ),
      // Use the routerConfig from GoRouter
      routerConfig: router,
    );
  }
}
