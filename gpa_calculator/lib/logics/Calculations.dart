class GPAandCGPACalculator {
  static Map<String, dynamic> calculateGPAandCGPA(int? numSemesters, Map<int, List<Map<String, String>>> courses) {
    double totalCGPA = 0;
    double totalCredits = 0;
    Map<int, double> semesterGPAs = {};

    for (int i = 0; i < (numSemesters ?? 0); i++) {
      double semesterPoints = 0;
      double semesterCredits = 0;
      for (var course in courses[i]!) {
        double credit = double.tryParse(course['credits'] ?? '0') ?? 0;
        double grade = double.tryParse(course['grade'] ?? '0') ?? 0;
        semesterPoints += credit * grade;
        semesterCredits += credit;
      }
      double semesterGPA = semesterCredits > 0 ? semesterPoints / semesterCredits : 0;
      semesterGPAs[i] = semesterGPA;
      totalCGPA += semesterGPA * semesterCredits;
      totalCredits += semesterCredits;
    }
    double finalCGPA = totalCredits > 0 ? totalCGPA / totalCredits : 0;

    return {
      'semesterGPAs': semesterGPAs,
      'finalCGPA': finalCGPA,
    };
  }
}