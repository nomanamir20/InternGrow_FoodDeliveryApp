import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_strategy/url_strategy.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';

// NOTE: Firebase initialization added in a later step once
// firebase_options.dart is generated via manual config (same approach
// used in Tasks 1 & 2 due to a known Windows CLI issue).
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const InternGrowFoodDeliveryApp());
}

class InternGrowFoodDeliveryApp extends StatelessWidget {
  const InternGrowFoodDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'InternGrow Food Delivery',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}