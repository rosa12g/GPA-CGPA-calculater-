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
        scaffoldBackgroundColor: Color(0xFFF3F5F9), 
        colorScheme: ColorScheme.light(
          primary: Color(0xFF1D4E89), 
          onPrimary: Colors.white, 
          surface: Color(0xFFF3F5F9), 
          background: Color(0xFFF3F5F9), 
          error: Color(0xFFD9534F), 
          onSurface: Color(0xFF444444), 
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D4E89), // Blue text for headline
          ),
          displayMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D4E89), // Blue text for headline
          ),
          titleLarge: TextStyle( // Replaces headline6
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D4E89), // Blue text for title
          ),
          bodyLarge: TextStyle(
            fontSize: 18,
            color: Color(0xFF444444), // Dark gray text for body
          ),
          bodyMedium: TextStyle( // Replaces bodyText2
            fontSize: 16,
            color: Color(0xFF444444), // Dark gray text for body
          ),
          labelLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D4E89), // Blue label color
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFF7F8FA), // Light fill color for inputs
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          labelStyle: TextStyle(color: Color(0xFF1D4E89)), // Blue label color
          hintStyle: TextStyle(color: Color(0xFFDB6C4A).withOpacity(0.7)), // Coral hint color
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF1D4E89), // Blue button color
            foregroundColor: Colors.white, // Text color (replaces onPrimary)
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        cardTheme: CardTheme(
          color: Color(0xFFFFFFFF), // White card color
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1D4E89), // Blue app bar
          elevation: 0,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFDB6C4A), // Coral floating action button color
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF1C1C1C), // Dark background color
        colorScheme: ColorScheme.dark(
          primary: Color(0xFF1D4E89), // Blue (Primary)
          onPrimary: Colors.white, // White text/icons on primary color
          surface: Color(0xFF333333), // Dark surface background
          background: Color(0xFF333333), // Dark background
          error: Color(0xFFD9534F), // Red for error states
          onSurface: Color(0xFFDBDBDB), // Light gray text for surface
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFFDBDBDB), // Light gray for headline
          ),
          displayMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFFDBDBDB), // Light gray for headline
          ),
          titleLarge: TextStyle( // Replaces headline6
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFFDBDBDB), // Light gray for title
          ),
          bodyLarge: TextStyle(
            fontSize: 18,
            color: Color(0xFFDBDBDB), // Light gray text for body
          ),
          bodyMedium: TextStyle( // Replaces bodyText2
            fontSize: 16,
            color: Color(0xFFDBDBDB), // Light gray text for body
          ),
          labelLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D4E89), // Blue label color
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF333333), // Dark fill color for inputs
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          labelStyle: TextStyle(color: Color(0xFF1D4E89)), // Blue label color
          hintStyle: TextStyle(color: Color(0xFFDB6C4A).withOpacity(0.7)), // Coral hint color
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF1D4E89), // Blue button color
            foregroundColor: Colors.white, 
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        cardTheme: CardTheme(
          color: Color(0xFF333333), 
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1D4E89), // Blue app bar
          elevation: 0,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFDB6C4A), // Coral floating action button color
        ),
      ),
      themeMode: ThemeMode.system, // Automatically switch between light and dark mode
      home: WelcomeScreen(),
    );
  }
}