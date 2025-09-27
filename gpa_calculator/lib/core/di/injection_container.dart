import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Features
import '../../features/course_management/data/datasources/course_local_datasource.dart';
import '../../features/course_management/data/repositories/course_repository_impl.dart';
import '../../features/course_management/domain/repositories/course_repository.dart';
import '../../features/course_management/domain/usecases/add_course.dart';
import '../../features/course_management/domain/usecases/update_course.dart';
import '../../features/course_management/domain/usecases/delete_course.dart';
import '../../features/course_management/domain/usecases/get_courses_by_semester.dart';

import '../../features/gpa_calculation/data/repositories/gpa_repository_impl.dart';
import '../../features/gpa_calculation/domain/repositories/gpa_repository.dart';
import '../../features/gpa_calculation/domain/usecases/calculate_gpa.dart';

import '../../features/analysis/data/datasources/analysis_remote_datasource.dart';
import '../../features/analysis/data/repositories/analysis_repository_impl.dart';
import '../../features/analysis/domain/repositories/analysis_repository.dart';
import '../../features/analysis/domain/usecases/analyze_performance.dart';

// Core
import '../network/network_info.dart';

// Presentation
import '../../features/course_management/presentation/bloc/course_bloc.dart';
import '../../features/gpa_calculation/presentation/bloc/gpa_bloc.dart';
import '../../features/analysis/presentation/bloc/analysis_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Course Management
  // Use cases
  sl.registerLazySingleton(() => AddCourse(sl()));
  sl.registerLazySingleton(() => UpdateCourse(sl()));
  sl.registerLazySingleton(() => DeleteCourse(sl()));
  sl.registerLazySingleton(() => GetCoursesBySemester(sl()));

  // Repository
  sl.registerLazySingleton<CourseRepository>(
    () => CourseRepositoryImpl(
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<CourseLocalDataSource>(
    () => CourseLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Features - GPA Calculation
  // Use cases
  sl.registerLazySingleton(() => CalculateGpa(sl()));

  // Repository
  sl.registerLazySingleton<GpaRepository>(
    () => GpaRepositoryImpl(),
  );

  //! Features - Analysis
  // Use cases
  sl.registerLazySingleton(() => AnalyzePerformance(sl()));

  // Repository
  sl.registerLazySingleton<AnalysisRepository>(
    () => AnalysisRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AnalysisRemoteDataSource>(
    () => AnalysisRemoteDataSourceImpl(client: sl()),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  //! Presentation - BLoCs
  sl.registerFactory(() => CourseBloc(
    addCourse: sl(),
    updateCourse: sl(),
    deleteCourse: sl(),
    getCoursesBySemester: sl(),
  ));

  sl.registerFactory(() => GpaBloc(
    calculateGpa: sl(),
  ));

  sl.registerFactory(() => AnalysisBloc(
    analyzePerformance: sl(),
  ));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
}
