import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CvFlutterApp());
}

class CvFlutterApp extends StatelessWidget {
  const CvFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon CV',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color.fromARGB(255, 58, 67, 117),

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 56, 248, 66),
          primary: const Color(0xFF101B32),
          secondary: const Color.fromARGB(255, 56, 248, 66),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF101B32),
          foregroundColor: Colors.white,
          centerTitle: false,
          elevation: 0,
        ),

        cardTheme: CardThemeData(
          color: const Color.fromARGB(255, 10, 10, 10),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ),
      ),

      home: const LoginScreen(),
    );
  }
}