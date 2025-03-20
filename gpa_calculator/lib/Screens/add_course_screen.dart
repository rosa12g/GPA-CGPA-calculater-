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
      appBar: AppBar(
        title: Text(
          widget.initialCourse == null
              ? 'Add Course - Semester ${widget.semester + 1}'
              : 'Edit Course - Semester ${widget.semester + 1}',
        ),
      ),
      body: SingleChildScrollView(
      
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _courseController,
                        decoration: InputDecoration(
                          labelText: 'Course Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Course name is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _creditController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Credit Hours',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: _validateCredit,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _gradeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Grade (4.0 scale)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: _validateGrade,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Save or update course
                    Navigator.pop(context, {
                      'course': _courseController.text,
                      'credits': _creditController.text,
                      'grade': _gradeController.text,
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  widget.initialCourse == null ? 'Save Course' : 'Update Course',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}