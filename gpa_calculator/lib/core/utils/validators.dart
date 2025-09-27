import '../constants/app_constants.dart';

class Validators {
  static String? validateCourseName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Course name is required';
    }
    if (value.length > AppConstants.maxCourseNameLength) {
      return 'Course name is too long';
    }
    return null;
  }

  static String? validateCredits(String? value) {
    if (value == null || value.isEmpty) {
      return 'Credit hours are required';
    }
    
    final creditValue = double.tryParse(value);
    if (creditValue == null) {
      return 'Enter a valid number';
    }
    
    if (creditValue < AppConstants.minCredits || creditValue > AppConstants.maxCredits) {
      return 'Credits must be between ${AppConstants.minCredits} and ${AppConstants.maxCredits}';
    }
    
    return null;
  }

  static String? validateGrade(String? value) {
    if (value == null || value.isEmpty) {
      return 'Grade is required';
    }
    
    final gradeValue = double.tryParse(value);
    if (gradeValue == null) {
      return 'Enter a valid number';
    }
    
    if (gradeValue < AppConstants.minGrade || gradeValue > AppConstants.maxGrade) {
      return 'Grade must be between ${AppConstants.minGrade} and ${AppConstants.maxGrade}';
    }
    
    return null;
  }

  static String? validateSemesterCount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Number of semesters is required';
    }
    
    final semesterCount = int.tryParse(value);
    if (semesterCount == null) {
      return 'Enter a valid number';
    }
    
    if (semesterCount < AppConstants.minSemesters || semesterCount > AppConstants.maxSemesters) {
      return 'Semesters must be between ${AppConstants.minSemesters} and ${AppConstants.maxSemesters}';
    }
    
    return null;
  }
}
