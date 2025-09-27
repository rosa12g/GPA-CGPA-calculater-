import 'package:dartz/dartz.dart';
import '../../../../shared/models/course.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/course_repository.dart';

class GetCoursesBySemester {
  final CourseRepository repository;

  GetCoursesBySemester(this.repository);

  Future<Either<Failure, List<Course>>> call(int semesterNumber) async {
    return await repository.getCoursesBySemester(semesterNumber);
  }
}
