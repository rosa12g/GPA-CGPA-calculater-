import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/models/course.dart';
import '../../../../shared/widgets/gradient_button.dart';

class AddCoursePage extends StatefulWidget {
  final int semester;
  final Course? initialCourse;

  const AddCoursePage({
    super.key,
    required this.semester,
    this.initialCourse,
  });

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  late TextEditingController _courseController;
  late TextEditingController _creditController;
  late TextEditingController _gradeController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _courseController = TextEditingController(text: widget.initialCourse?.name ?? '');
    _creditController = TextEditingController(text: widget.initialCourse?.credits.toString() ?? '');
    _gradeController = TextEditingController(text: widget.initialCourse?.grade.toString() ?? '');
  }

  @override
  void dispose() {
    _courseController.dispose();
    _creditController.dispose();
    _gradeController.dispose();
    super.dispose();
  }

  void _saveCourse() {
    if (_formKey.currentState!.validate()) {
      final course = Course(
        name: _courseController.text.trim(),
        credits: double.parse(_creditController.text),
        grade: double.parse(_gradeController.text),
        id: widget.initialCourse?.id,
      );
      context.pop(course);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          widget.initialCourse == null
              ? 'Add Course - Sem ${widget.semester + 1}'
              : 'Edit Course - Sem ${widget.semester + 1}',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A1A), Color(0xFF263238)],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: true,
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                          elevation: AppConstants.cardElevation,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                          ),
                          color: Colors.grey[850],
                          child: Padding(
                            padding: const EdgeInsets.all(AppConstants.defaultPadding),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _courseController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'Course Name',
                                    labelStyle: const TextStyle(color: Colors.cyanAccent),
                                    filled: true,
                                    fillColor: Colors.grey[800],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Colors.cyanAccent, width: 2),
                                    ),
                                    prefixIcon: const Icon(Icons.book, color: Colors.cyanAccent),
                                  ),
                                  validator: Validators.validateCourseName,
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _creditController,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'Credit Hours',
                                    labelStyle: const TextStyle(color: Colors.cyanAccent),
                                    filled: true,
                                    fillColor: Colors.grey[800],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Colors.cyanAccent, width: 2),
                                    ),
                                    prefixIcon: const Icon(Icons.hourglass_empty, color: Colors.cyanAccent),
                                  ),
                                  validator: Validators.validateCredits,
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _gradeController,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'Grade (0-4.0)',
                                    labelStyle: const TextStyle(color: Colors.cyanAccent),
                                    filled: true,
                                    fillColor: Colors.grey[800],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Colors.cyanAccent, width: 2),
                                    ),
                                    prefixIcon: const Icon(Icons.grade, color: Colors.cyanAccent),
                                  ),
                                  validator: Validators.validateGrade,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        GradientButton(
                          text: widget.initialCourse == null ? 'Save Course' : 'Update Course',
                          onPressed: _saveCourse,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
