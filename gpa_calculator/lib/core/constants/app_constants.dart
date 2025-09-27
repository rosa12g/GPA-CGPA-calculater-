class AppConstants {
  // API Constants
  static const String geminiBaseUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent";
  static const String geminiApiKey = "GEMINI_API_KEY";
  
  // GPA Constants
  static const double minGrade = 0.0;
  static const double maxGrade = 4.0;
  static const double minCredits = 0.0;
  static const double maxCredits = 10.0;
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double cardElevation = 8.0;
  static const double borderRadius = 16.0;
  static const double buttonBorderRadius = 30.0;
  
  // Validation
  static const int maxSemesters = 20;
  static const int minSemesters = 1;
  static const int maxCourseNameLength = 100;
  
  // Error Messages
  static const String networkErrorMessage = "Network error occurred. Please check your connection.";
  static const String unknownErrorMessage = "An unknown error occurred.";
  static const String invalidDataErrorMessage = "Invalid data provided.";
}
