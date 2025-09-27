import 'package:dartz/dartz.dart';
import '../../../../shared/models/gpa_result.dart';
import '../../../../shared/models/semester.dart';
import '../../../../core/errors/failures.dart';

abstract class GpaRepository {
  Future<Either<Failure, GpaResult>> calculateGpa(List<Semester> semesters);
  Future<Either<Failure, double>> calculateSemesterGpa(Semester semester);
  Future<Either<Failure, double>> calculateCgpa(List<Semester> semesters);
}
