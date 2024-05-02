import 'package:flutter/material.dart';
import 'package:thr_client/pages/home.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.from(
        colorScheme: const ColorScheme.dark(
          //background: Colors.black
        ),
        useMaterial3: true,
      ),
      home: const HomePage()
    );
  }
}
