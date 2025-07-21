import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'welcome_screen.dart';
import 'auth_screen.dart';

void main() {
  runApp(const CoventryUniversityApp());
}

class CoventryUniversityApp extends StatelessWidget {
  const CoventryUniversityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coventry University',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF4A90E2),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      home: const WelcomeScreen(),
      routes: {
        '/auth': (context) => const AuthScreen(),
      },
    );
  }
}