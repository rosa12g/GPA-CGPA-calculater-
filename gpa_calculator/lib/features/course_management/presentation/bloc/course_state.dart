part of 'course_bloc.dart';

abstract class CourseState extends Equatable {
  const CourseState();

  @override
  List<Object?> get props => [];
}

class CourseInitial extends CourseState {}

class CourseLoading extends CourseState {}

class CourseLoaded extends CourseState {
  final List<Course> courses;
  
  const CourseLoaded(this.courses);
  
  @override
  List<Object?> get props => [courses];
}

class CourseError extends CourseState {
  final String message;
  
  const CourseError(this.message);
  
  @override
  List<Object?> get props => [message];
}
