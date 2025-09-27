import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'core/di/injection_container.dart' as di;
import 'features/course_management/presentation/bloc/course_bloc.dart';
import 'features/gpa_calculation/presentation/bloc/gpa_bloc.dart';
import 'features/analysis/presentation/bloc/analysis_bloc.dart';
import 'presentation/pages/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CourseBloc>(
          create: (_) => GetIt.instance<CourseBloc>(),
        ),
        BlocProvider<GpaBloc>(
          create: (_) => GetIt.instance<GpaBloc>(),
        ),
        BlocProvider<AnalysisBloc>(
          create: (_) => GetIt.instance<AnalysisBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'GradeMaster',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const WelcomePage(),
      ),
    );
  }
}
