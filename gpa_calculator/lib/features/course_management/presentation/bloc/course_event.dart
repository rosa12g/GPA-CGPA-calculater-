part of 'course_bloc.dart';

abstract class CourseEvent extends Equatable {
  const CourseEvent();

  @override
  List<Object?> get props => [];
}

class LoadCourses extends CourseEvent {
  final int semesterNumber;
  
  const LoadCourses(this.semesterNumber);
  
  @override
  List<Object?> get props => [semesterNumber];
}

class AddCourseEvent extends CourseEvent {
  final Course course;
  
  const AddCourseEvent(this.course);
  
  @override
  List<Object?> get props => [course];
}

class UpdateCourseEvent extends CourseEvent {
  final Course course;
  
  const UpdateCourseEvent(this.course);
  
  @override
  List<Object?> get props => [course];
}

class DeleteCourseEvent extends CourseEvent {
  final int courseId;
  
  const DeleteCourseEvent(this.courseId);
  
  @override
  List<Object?> get props => [courseId];
}
