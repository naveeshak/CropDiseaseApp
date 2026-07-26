import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'pages.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Crop Doctor',
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.green,
          ),
          // simple language switching (English/Sinhala)
          locale: Locale(appState.languageCode),

          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          
          supportedLocales: const [
            Locale('en'),
            Locale('si'),
          ],

          initialRoute: HomeScreen.routeName,
          routes: {
            HomeScreen.routeName: (_) => const HomeScreen(),
            CameraScreen.routeName: (_) => const CameraScreen(),
            ResultScreen.routeName: (_) => const ResultScreen(),
            HistoryScreen.routeName: (_) => const HistoryScreen(),
            SettingsScreen.routeName: (_) => const SettingsScreen(),
          },
        );
      },
    );
  }
}