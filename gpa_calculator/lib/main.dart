import 'package:flutter/material.dart';
import 'package:gpa_calculator/Screens/Welcome.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFF5F5F5), // Light gray background
        colorScheme: ColorScheme.light(
          primary: Color(0xFF1E3A8A), // Deep blue
          onPrimary: Colors.white, // White text/icons on primary color
          secondary: Color(0xFF3B82F6), // Bright blue
          onSecondary: Colors.white, // White text/icons on secondary color
          surface: Colors.white, // White surface
          background: Color(0xFFF5F5F5), // Light gray background
          error: Color(0xFFDC2626), // Red for errors
          onSurface: Color(0xFF1E293B), // Dark blue-gray text
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)), // Deep blue
          displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)), // Deep blue
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)), // Dark blue-gray
          bodyLarge: TextStyle(fontSize: 18, color: Color(0xFF1E293B)), // Dark blue-gray
          bodyMedium: TextStyle(fontSize: 16, color: Color(0xFF1E293B)), // Dark blue-gray
          labelLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3B82F6)), // Bright blue
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white, // White background for input fields
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          labelStyle: TextStyle(color: Color(0xFF1E3A8A)), // Deep blue
          hintStyle: TextStyle(color: Color(0xFF3B82F6).withOpacity(0.7)), // Bright blue with opacity
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF1E3A8A), // Deep blue
            foregroundColor: Colors.white, // White text
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        cardTheme: CardTheme(
          color: Colors.white, // White background for cards
          elevation: 4, // Subtle shadow
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1E3A8A), // Deep blue
          elevation: 0, // No shadow
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white), // White icons
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF3B82F6), // Bright blue
        ),
      ),
      home: WelcomeScreen(), // Replace with your home screen
    );
  }
}