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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialCourse == null ? 'Add Course - Semester ${widget.semester + 1}' : 'Edit Course - Semester ${widget.semester + 1}',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _courseController,
              decoration: InputDecoration(labelText: 'Course Name'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _creditController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Credit Hours'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _gradeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Grade (4.0 scale)'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_courseController.text.isNotEmpty && _creditController.text.isNotEmpty && _gradeController.text.isNotEmpty) {
                  Navigator.pop(context, {
                    'course': _courseController.text,
                    'credits': _creditController.text,
                    'grade': _gradeController.text,
                  });
                }
              },
              child: Text(widget.initialCourse == null ? 'Save Course' : 'Update Course'),
            ),
          ],
        ),
      ),
    );
  }
}