import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../shared/models/course.dart';
import '../../domain/usecases/add_course.dart';
import '../../domain/usecases/update_course.dart';
import '../../domain/usecases/delete_course.dart';
import '../../domain/usecases/get_courses_by_semester.dart';

part 'course_event.dart';
part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final AddCourse addCourse;
  final UpdateCourse updateCourse;
  final DeleteCourse deleteCourse;
  final GetCoursesBySemester getCoursesBySemester;

  CourseBloc({
    required this.addCourse,
    required this.updateCourse,
    required this.deleteCourse,
    required this.getCoursesBySemester,
  }) : super(CourseInitial()) {
    on<LoadCourses>(_onLoadCourses);
    on<AddCourseEvent>(_onAddCourse);
    on<UpdateCourseEvent>(_onUpdateCourse);
    on<DeleteCourseEvent>(_onDeleteCourse);
  }

  Future<void> _onLoadCourses(LoadCourses event, Emitter<CourseState> emit) async {
    emit(CourseLoading());
    
    final result = await getCoursesBySemester(event.semesterNumber);
    result.fold(
      (failure) => emit(CourseError(failure.message)),
      (courses) => emit(CourseLoaded(courses)),
    );
  }

  Future<void> _onAddCourse(AddCourseEvent event, Emitter<CourseState> emit) async {
    emit(CourseLoading());
    
    final result = await addCourse(event.course);
    result.fold(
      (failure) => emit(CourseError(failure.message)),
      (course) {
        if (state is CourseLoaded) {
          final currentCourses = (state as CourseLoaded).courses;
          emit(CourseLoaded([...currentCourses, course]));
        } else {
          emit(CourseLoaded([course]));
        }
      },
    );
  }

  Future<void> _onUpdateCourse(UpdateCourseEvent event, Emitter<CourseState> emit) async {
    emit(CourseLoading());
    
    final result = await updateCourse(event.course);
    result.fold(
      (failure) => emit(CourseError(failure.message)),
      (updatedCourse) {
        if (state is CourseLoaded) {
          final currentCourses = (state as CourseLoaded).courses;
          final updatedCourses = currentCourses.map((course) {
            return course.id == updatedCourse.id ? updatedCourse : course;
          }).toList();
          emit(CourseLoaded(updatedCourses));
        }
      },
    );
  }

  Future<void> _onDeleteCourse(DeleteCourseEvent event, Emitter<CourseState> emit) async {
    emit(CourseLoading());
    
    final result = await deleteCourse(event.courseId);
    result.fold(
      (failure) => emit(CourseError(failure.message)),
      (_) {
        if (state is CourseLoaded) {
          final currentCourses = (state as CourseLoaded).courses;
          final updatedCourses = currentCourses.where((course) => course.id != event.courseId).toList();
          emit(CourseLoaded(updatedCourses));
        }
      },
    );
  }
}
