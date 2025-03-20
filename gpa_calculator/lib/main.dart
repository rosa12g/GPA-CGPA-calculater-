import 'package:flutter/material.dart';
import 'package:gpa_calculator/Welcome.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFFFF8F2), // Creamy white
        colorScheme: ColorScheme.light(
          primary: Color(0xFF8A4F2A), // Deep brown
          onPrimary: Colors.white, // White text/icons on primary color
          secondary: Color(0xFFD57A66), // Warm coral
          onSecondary: Colors.white,
          surface: Color(0xFFF3E5D8), // Light beige
          background: Color(0xFFFFF8F2), // Background color
          error: Color(0xFFBA3F1D), // Strong red for errors
          onSurface: Color(0xFF5C4033), // Dark brown text
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF8A4F2A)),
          displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF8A4F2A)),
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF5C4033)),
          bodyLarge: TextStyle(fontSize: 18, color: Color(0xFF5C4033)),
          bodyMedium: TextStyle(fontSize: 16, color: Color(0xFF5C4033)),
          labelLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFD57A66)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFF3E5D8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          labelStyle: TextStyle(color: Color(0xFF8A4F2A)),
          hintStyle: TextStyle(color: Color(0xFFD57A66).withOpacity(0.7)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF8A4F2A),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        cardTheme: CardTheme(
          color: Color(0xFFFFF8F2),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF8A4F2A),
          elevation: 0,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFD57A66),
        ),
      ),
      home: WelcomeScreen(),
    );
  }
}
