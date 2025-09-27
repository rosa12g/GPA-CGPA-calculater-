import 'package:dartz/dartz.dart';
import '../../../../shared/models/course.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/course_repository.dart';
import '../datasources/course_local_datasource.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CourseRepositoryImpl({
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Course>>> getAllCourses() async {
    try {
      final courses = await localDataSource.getAllCourses();
      return Right(courses);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Course>> getCourseById(int id) async {
    try {
      final course = await localDataSource.getCourseById(id);
      return Right(course);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Course>> addCourse(Course course) async {
    try {
      final newCourse = await localDataSource.addCourse(course);
      return Right(newCourse);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Course>> updateCourse(Course course) async {
    try {
      final updatedCourse = await localDataSource.updateCourse(course);
      return Right(updatedCourse);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCourse(int id) async {
    try {
      await localDataSource.deleteCourse(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Course>>> getCoursesBySemester(int semesterNumber) async {
    try {
      final courses = await localDataSource.getCoursesBySemester(semesterNumber);
      return Right(courses);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }
}
