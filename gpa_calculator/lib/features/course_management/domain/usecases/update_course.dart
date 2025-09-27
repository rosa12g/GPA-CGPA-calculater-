import 'package:dartz/dartz.dart';
import '../../../../shared/models/course.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/course_repository.dart';

class UpdateCourse {
  final CourseRepository repository;

  UpdateCourse(this.repository);

  Future<Either<Failure, Course>> call(Course course) async {
    return await repository.updateCourse(course);
  }
}
