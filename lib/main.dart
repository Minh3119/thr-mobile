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
      // showSemanticsDebugger: false,
      // debugShowMaterialGrid: false,
      // showPerformanceOverlay: false,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.from(
        colorScheme: ColorScheme.dark(
          //background: Colors.black
          primary: Colors.deepOrangeAccent,
          secondary: Colors.brown.withGreen(100).withBlue(90),
          
        ),
        useMaterial3: true,
      ),
      home: const HomePage()
    );
  }
}
