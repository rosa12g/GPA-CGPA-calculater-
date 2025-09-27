import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/course_repository.dart';

class DeleteCourse {
  final CourseRepository repository;

  DeleteCourse(this.repository);

  Future<Either<Failure, void>> call(int courseId) async {
    return await repository.deleteCourse(courseId);
  }
}
