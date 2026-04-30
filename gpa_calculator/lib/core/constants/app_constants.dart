class AppConstants {
  // API
  static const String geminiBaseUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";
  static const String geminiApiKey = "GEMINI_API_KEY";

  // GPA
  static const double minGrade = 0.0;
  static const double maxGrade = 4.0;
  static const double minCredits = 0.0;
  static const double maxCredits = 10.0;

  // UI
  static const double defaultPadding = 16.0;
  static const double cardElevation = 0.0;
  static const double borderRadius = 16.0;
  static const double buttonBorderRadius = 12.0;

  // Validation
  static const int maxSemesters = 20;
  static const int minSemesters = 1;
  static const int maxCourseNameLength = 100;

  // Error Messages
  static const String networkErrorMessage =
      "Network error occurred. Please check your connection.";
  static const String unknownErrorMessage = "An unknown error occurred.";
  static const String invalidDataErrorMessage = "Invalid data provided.";

  // Grade options: label -> GPA points
  static const Map<String, double> gradeOptions = {
    'A+': 4.0,
    'A': 4.0,
    'A-': 3.7,
    'B+': 3.3,
    'B': 3.0,
    'B-': 2.7,
    'C+': 2.3,
    'C': 2.0,
    'C-': 1.7,
    'D+': 1.3,
    'D': 1.0,
    'F': 0.0,
  };

  // GPA thresholds
  static const double gpaHighThreshold = 3.5;
  static const double gpaMidThreshold = 2.5;

  // Local storage key
  static const String coursesStorageKey = 'saved_courses_v2';
}
