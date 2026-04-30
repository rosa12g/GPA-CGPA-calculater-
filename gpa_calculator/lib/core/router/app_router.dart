import 'package:go_router/go_router.dart';
import '../../shared/models/course.dart';
import '../../features/welcome/presentation/pages/welcome_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/course_management/presentation/pages/add_course_page.dart';
import '../../features/analysis/presentation/pages/analysis_page.dart';


abstract class AppRoutes {
  static const welcome = '/';
  static const home = '/home';
  static const addCourse = '/add-course';
  static const analysis = '/analysis';
}


final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.welcome,
  routes: [
    GoRoute(
      path: AppRoutes.welcome,
      builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.addCourse,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return AddCoursePage(
          semester: extra['semester'] as int,
          initialCourse: extra['initialCourse'] as Course?,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.analysis,
      builder: (context, state) {
        final grades = state.extra as Map<String, double>;
        return AnalysisPage(grades: grades);
      },
    ),
  ],
);
