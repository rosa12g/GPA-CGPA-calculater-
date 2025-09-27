import 'package:dartz/dartz.dart';
import '../../../../shared/models/gpa_result.dart';
import '../../../../shared/models/semester.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/gpa_repository.dart';

class GpaRepositoryImpl implements GpaRepository {
  @override
  Future<Either<Failure, GpaResult>> calculateGpa(List<Semester> semesters) async {
    try {
      final Map<int, double> semesterGpas = {};
      double totalCgpaPoints = 0.0;
      double totalCredits = 0.0;

      for (final semester in semesters) {
        final semesterGpa = semester.calculateGPA();
        semesterGpas[semester.number] = semesterGpa;
        
        totalCgpaPoints += semesterGpa * semester.totalCredits;
        totalCredits += semester.totalCredits;
      }

      final finalCgpa = totalCredits > 0 ? totalCgpaPoints / totalCredits : 0.0;

      final result = GpaResult(
        semesterGpas: semesterGpas,
        finalCgpa: finalCgpa,
        semesters: semesters,
      );

      return Right(result);
    } catch (e) {
      return Left(UnknownFailure('Failed to calculate GPA: $e'));
    }
  }

  @override
  Future<Either<Failure, double>> calculateSemesterGpa(Semester semester) async {
    try {
      final gpa = semester.calculateGPA();
      return Right(gpa);
    } catch (e) {
      return Left(UnknownFailure('Failed to calculate semester GPA: $e'));
    }
  }

  @override
  Future<Either<Failure, double>> calculateCgpa(List<Semester> semesters) async {
    try {
      double totalCgpaPoints = 0.0;
      double totalCredits = 0.0;

      for (final semester in semesters) {
        final semesterGpa = semester.calculateGPA();
        totalCgpaPoints += semesterGpa * semester.totalCredits;
        totalCredits += semester.totalCredits;
      }

      final cgpa = totalCredits > 0 ? totalCgpaPoints / totalCredits : 0.0;
      return Right(cgpa);
    } catch (e) {
      return Left(UnknownFailure('Failed to calculate CGPA: $e'));
    }
  }
}
