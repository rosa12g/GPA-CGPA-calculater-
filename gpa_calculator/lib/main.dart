import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

import 'core/di/injection_container.dart' as di;
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/course_management/presentation/bloc/course_bloc.dart';
import 'features/gpa_calculation/presentation/bloc/gpa_bloc.dart';
import 'features/analysis/presentation/bloc/analysis_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CourseBloc>(create: (_) => GetIt.instance<CourseBloc>()),
        BlocProvider<GpaBloc>(create: (_) => GetIt.instance<GpaBloc>()),
        BlocProvider<AnalysisBloc>(create: (_) => GetIt.instance<AnalysisBloc>()),
      ],
      child: MaterialApp.router(
        title: 'GradeMaster',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        routerConfig: appRouter,
      ),
    );
  }
}
