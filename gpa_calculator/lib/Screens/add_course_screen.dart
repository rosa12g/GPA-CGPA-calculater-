import 'package:flutter/material.dart';

class AddCourseScreen extends StatefulWidget {
  final int semester;
  final Map<String, String>? initialCourse;

  AddCourseScreen({required this.semester, this.initialCourse});

  @override
  _AddCourseScreenState createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  late TextEditingController _courseController;
  late TextEditingController _creditController;
  late TextEditingController _gradeController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _courseController = TextEditingController(text: widget.initialCourse?['course'] ?? '');
    _creditController = TextEditingController(text: widget.initialCourse?['credits'] ?? '');
    _gradeController = TextEditingController(text: widget.initialCourse?['grade'] ?? '');
  }

  @override
  void dispose() {
    _courseController.dispose();
    _creditController.dispose();
    _gradeController.dispose();
    super.dispose();
  }

  String? _validateCredit(String? value) {
    if (value == null || value.isEmpty) {
      return 'Credit hours are required';
    }
    if (double.tryParse(value) == null) {
      return 'Enter a valid number';
    }
    return null;
  }

  String? _validateGrade(String? value) {
    if (value == null || value.isEmpty) {
      return 'Grade is required';
    }
    if (double.tryParse(value) == null) {
      return 'Enter a valid number';
    }
    double grade = double.parse(value);
    if (grade < 0 || grade > 4.0) {
      return 'Grade must be between 0 and 4.0';
    }
    return null;
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
          style: TextStyle(
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey[900]!,
              Colors.blueGrey[900]!,
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: true,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          color: Colors.grey[850],
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _courseController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'Course Name',
                                    labelStyle: TextStyle(color: Colors.cyanAccent),
                                    filled: true,
                                    fillColor: Colors.grey[800],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.cyanAccent, width: 2),
                                    ),
                                    prefixIcon: Icon(Icons.book, color: Colors.cyanAccent),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Course name is required';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  controller: _creditController,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'Credit Hours',
                                    labelStyle: TextStyle(color: Colors.cyanAccent),
                                    filled: true,
                                    fillColor: Colors.grey[800],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.cyanAccent, width: 2),
                                    ),
                                    prefixIcon: Icon(Icons.hourglass_empty, color: Colors.cyanAccent),
                                  ),
                                  validator: _validateCredit,
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  controller: _gradeController,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'Grade (0-4.0)',
                                    labelStyle: TextStyle(color: Colors.cyanAccent),
                                    filled: true,
                                    fillColor: Colors.grey[800],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.cyanAccent, width: 2),
                                    ),
                                    prefixIcon: Icon(Icons.grade, color: Colors.cyanAccent),
                                  ),
                                  validator: _validateGrade,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.pop(context, {
                                'course': _courseController.text,
                                'credits': _creditController.text,
                                'grade': _gradeController.text,
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 10,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.cyanAccent, Colors.greenAccent],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                            child: Text(
                              widget.initialCourse == null ? 'Save Course' : 'Update Course',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[900],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20), // Extra padding at the bottom
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