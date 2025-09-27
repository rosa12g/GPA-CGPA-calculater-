import 'package:equatable/equatable.dart';
import 'course.dart';

class Semester extends Equatable {
  final int number;
  final List<Course> courses;
  final double? gpa;

  const Semester({
    required this.number,
    required this.courses,
    this.gpa,
  });

  Semester copyWith({
    int? number,
    List<Course>? courses,
    double? gpa,
  }) {
    return Semester(
      number: number ?? this.number,
      courses: courses ?? this.courses,
      gpa: gpa ?? this.gpa,
    );
  }

  double calculateGPA() {
    if (courses.isEmpty) return 0.0;
    
    double totalPoints = 0.0;
    double totalCredits = 0.0;
    
    for (final course in courses) {
      totalPoints += course.credits * course.grade;
      totalCredits += course.credits;
    }
    
    return totalCredits > 0 ? totalPoints / totalCredits : 0.0;
  }

  double get totalCredits {
    return courses.fold(0.0, (sum, course) => sum + course.credits);
  }

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'courses': courses.map((course) => course.toMap()).toList(),
      'gpa': gpa,
    };
  }

  factory Semester.fromMap(Map<String, dynamic> map) {
    return Semester(
      number: map['number'] ?? 0,
      courses: (map['courses'] as List<dynamic>?)
          ?.map((course) => Course.fromMap(course))
          .toList() ?? [],
      gpa: map['gpa']?.toDouble(),
    );
  }

  @override
  List<Object?> get props => [number, courses, gpa];
}
