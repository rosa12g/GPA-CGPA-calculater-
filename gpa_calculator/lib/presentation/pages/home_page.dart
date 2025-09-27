import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/gpa_calculation/presentation/bloc/gpa_bloc.dart';
import '../../shared/models/course.dart';
import '../../shared/models/semester.dart';
import '../widgets/semester_card.dart';
import '../widgets/gradient_button.dart';
import 'add_course_page.dart';
import 'analysis_page.dart';
import '../../core/constants/app_constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? _numSemesters;
  final Map<int, List<Course>> _courses = {};
  Map<int, double>? _semesterGPAs;
  double? _finalCGPA;

  void _askSemesterCount() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController semesterController = TextEditingController();
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Enter Semester Count',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          content: TextField(
            controller: semesterController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Number of semesters',
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                int? num = int.tryParse(semesterController.text);
                if (num != null && num > 0 && num <= AppConstants.maxSemesters) {
                  setState(() {
                    _numSemesters = num;
                    for (int i = 0; i < num; i++) {
                      _courses[i] = [];
                    }
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid number of semesters'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              child: const Text('OK', style: TextStyle(color: Colors.cyanAccent)),
            ),
          ],
        );
      },
    );
  }

  void _calculateGPAandCGPA() {
    final semesters = _courses.entries
        .map((entry) => Semester(number: entry.key, courses: entry.value))
        .toList();

    context.read<GpaBloc>().add(CalculateGpaEvent(semesters));
  }

  void _navigateToAnalysis() {
    Map<String, double> grades = {};
    _courses.forEach((semester, courses) {
      for (var course in courses) {
        grades[course.name] = course.grade;
      }
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnalysisPage(grades: grades),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GradeMaster',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1A1A),
              Color(0xFF263238),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              children: [
                GradientButton(
                  text: 'Setup Semesters',
                  onPressed: _askSemesterCount,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: BlocListener<GpaBloc, GpaState>(
                    listener: (context, state) {
                      if (state is GpaCalculated) {
                        setState(() {
                          _semesterGPAs = state.result.semesterGpas;
                          _finalCGPA = state.result.finalCgpa;
                        });
                      } else if (state is GpaError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    },
                    child: ListView.builder(
                      itemCount: _numSemesters ?? 0,
                      itemBuilder: (context, semester) {
                        return SemesterCard(
                          semesterNumber: semester,
                          courses: _courses[semester] ?? [],
                          semesterGpa: _semesterGPAs?[semester],
                          onAddCourse: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddCoursePage(semester: semester),
                              ),
                            );
                            if (result != null && result is Course) {
                              setState(() {
                                _courses[semester]!.add(result);
                                _semesterGPAs = null;
                                _finalCGPA = null;
                              });
                            }
                          },
                          onEditCourse: (courseIndex) async {
                            final course = _courses[semester]![courseIndex];
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddCoursePage(
                                  semester: semester,
                                  initialCourse: course,
                                ),
                              ),
                            );
                            if (result != null && result is Course) {
                              setState(() {
                                _courses[semester]![courseIndex] = result;
                                _semesterGPAs = null;
                                _finalCGPA = null;
                              });
                            }
                          },
                          onDeleteCourse: (courseIndex) {
                            setState(() {
                              _courses[semester]!.removeAt(courseIndex);
                              _semesterGPAs = null;
                              _finalCGPA = null;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ),
                if (_finalCGPA != null) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.cyanAccent, Colors.greenAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Text(
                      'Final CGPA: ${_finalCGPA!.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GradientButton(
                      text: 'Calculate GPA',
                      onPressed: _numSemesters != null ? _calculateGPAandCGPA : null,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    ),
                    GradientButton(
                      text: 'Analyze',
                      onPressed: _finalCGPA != null ? _navigateToAnalysis : null,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
