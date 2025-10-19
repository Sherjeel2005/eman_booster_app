import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/widgets/gradient_background.dart';
import 'features/home/views/SplashScreen.dart';
import 'features/home/views/home_screen.dart';
import 'features/video/views/video_list.dart';

void main() {
  runApp(const ProviderScope(child: EmaanBoosterApp()));
}

class EmaanBoosterApp extends StatelessWidget {
  const EmaanBoosterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emaan Booster',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.dark,
      ),
      home: const GlobalBackgroundWrapper(),
    );
  }
}

/// ✅ This widget wraps your entire navigation inside a single animated star background
class GlobalBackgroundWrapper extends StatelessWidget {
  const GlobalBackgroundWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Navigator(
        initialRoute: '/splash',
        onGenerateRoute: (settings) {
          Widget page;

          switch (settings.name) {
            case '/home':
              page = const HomeScreen();
              break;

            case '/videos':
              final args = settings.arguments as Map;
              page = VideoListPage(
                category: args['category'],
                heroTag: args['heroTag'],
              );
              break;

            default:
              page = const SplashScreen();
          }

          return MaterialPageRoute(
            builder: (_) => page,
            settings: settings,
          );
        },
      ),
    );
  }
}
