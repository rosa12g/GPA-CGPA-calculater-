import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../shared/models/course.dart';
import '../../../../core/errors/exceptions.dart';

abstract class CourseLocalDataSource {
  Future<List<Course>> getAllCourses();
  Future<Course> getCourseById(int id);
  Future<Course> addCourse(Course course);
  Future<Course> updateCourse(Course course);
  Future<void> deleteCourse(int id);
  Future<List<Course>> getCoursesBySemester(int semesterNumber);
}

class CourseLocalDataSourceImpl implements CourseLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _coursesKey = 'courses';

  CourseLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<Course>> getAllCourses() async {
    try {
      final coursesJson = sharedPreferences.getStringList(_coursesKey) ?? [];
      return coursesJson
          .map((courseStr) => Course.fromMap(jsonDecode(courseStr)))
          .toList();
    } catch (e) {
      throw CacheException('Failed to get courses: $e');
    }
  }

  @override
  Future<Course> getCourseById(int id) async {
    try {
      final courses = await getAllCourses();
      final course = courses.firstWhere((course) => course.id == id);
      return course;
    } catch (e) {
      throw CacheException('Course not found: $e');
    }
  }

  @override
  Future<Course> addCourse(Course course) async {
    try {
      final courses = await getAllCourses();
      final newCourse = course.copyWith(id: DateTime.now().millisecondsSinceEpoch);
      courses.add(newCourse);
      await _saveCourses(courses);
      return newCourse;
    } catch (e) {
      throw CacheException('Failed to add course: $e');
    }
  }

  @override
  Future<Course> updateCourse(Course course) async {
    try {
      final courses = await getAllCourses();
      final index = courses.indexWhere((c) => c.id == course.id);
      if (index == -1) {
        throw CacheException('Course not found');
      }
      courses[index] = course;
      await _saveCourses(courses);
      return course;
    } catch (e) {
      throw CacheException('Failed to update course: $e');
    }
  }

  @override
  Future<void> deleteCourse(int id) async {
    try {
      final courses = await getAllCourses();
      courses.removeWhere((course) => course.id == id);
      await _saveCourses(courses);
    } catch (e) {
      throw CacheException('Failed to delete course: $e');
    }
  }

  @override
  Future<List<Course>> getCoursesBySemester(int semesterNumber) async {
    try {
      final courses = await getAllCourses();
      // For now, we'll return all courses since we don't have semester info in Course model
      // In a real app, you'd add semester field to Course model
      return courses;
    } catch (e) {
      throw CacheException('Failed to get courses by semester: $e');
    }
  }

  Future<void> _saveCourses(List<Course> courses) async {
    final coursesJson = courses
        .map((course) => jsonEncode(course.toMap()))
        .toList();
    await sharedPreferences.setStringList(_coursesKey, coursesJson);
  }
}
