import 'package:dartz/dartz.dart';
import '../../../../shared/models/gpa_result.dart';
import '../../../../shared/models/semester.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/gpa_repository.dart';

class CalculateGpa {
  final GpaRepository repository;

  CalculateGpa(this.repository);

  Future<Either<Failure, GpaResult>> call(List<Semester> semesters) async {
    return await repository.calculateGpa(semesters);
  }
}
