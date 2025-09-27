import '../../../../shared/models/course.dart';
import '../../../../core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class CourseRepository {
  Future<Either<Failure, List<Course>>> getAllCourses();
  Future<Either<Failure, Course>> getCourseById(int id);
  Future<Either<Failure, Course>> addCourse(Course course);
  Future<Either<Failure, Course>> updateCourse(Course course);
  Future<Either<Failure, void>> deleteCourse(int id);
  Future<Either<Failure, List<Course>>> getCoursesBySemester(int semesterNumber);
}
