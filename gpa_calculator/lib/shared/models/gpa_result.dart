import 'package:equatable/equatable.dart';
import 'semester.dart';

class GpaResult extends Equatable {
  final Map<int, double> semesterGpas;
  final double finalCgpa;
  final List<Semester> semesters;

  const GpaResult({
    required this.semesterGpas,
    required this.finalCgpa,
    required this.semesters,
  });

  GpaResult copyWith({
    Map<int, double>? semesterGpas,
    double? finalCgpa,
    List<Semester>? semesters,
  }) {
    return GpaResult(
      semesterGpas: semesterGpas ?? this.semesterGpas,
      finalCgpa: finalCgpa ?? this.finalCgpa,
      semesters: semesters ?? this.semesters,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'semesterGpas': semesterGpas,
      'finalCgpa': finalCgpa,
      'semesters': semesters.map((semester) => semester.toMap()).toList(),
    };
  }

  factory GpaResult.fromMap(Map<String, dynamic> map) {
    return GpaResult(
      semesterGpas: Map<int, double>.from(map['semesterGpas'] ?? {}),
      finalCgpa: (map['finalCgpa'] ?? 0.0).toDouble(),
      semesters: (map['semesters'] as List<dynamic>?)
          ?.map((semester) => Semester.fromMap(semester))
          .toList() ?? [],
    );
  }

  @override
  List<Object?> get props => [semesterGpas, finalCgpa, semesters];
}
