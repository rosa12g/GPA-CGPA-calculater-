import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? _numSemesters;
  final Map<int, List<Map<String, String>>> _courses = {};
  Map<int, double>? _semesterGPAs;
  double? _finalCGPA;

  void _askSemesterCount() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController semesterController = TextEditingController();
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text('Number of Semesters', style: Theme.of(context).textTheme.titleLarge),
          content: TextField(
            controller: semesterController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter number of semesters',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                int? num = int.tryParse(semesterController.text);
                if (num != null && num > 0) {
                  setState(() {
                    _numSemesters = num;
                    for (int i = 0; i < num; i++) {
                      _courses[i] = [];
                    }
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('OK', style: TextStyle(color: Color(0xFF8A4F2A))),
            ),
          ],
        );
      },
    );
  }

  void _calculateGPAandCGPA() {
    double totalCGPA = 0;
    double totalCredits = 0;
    Map<int, double> semesterGPAs = {};

    for (int i = 0; i < (_numSemesters ?? 0); i++) {
      double semesterPoints = 0;
      double semesterCredits = 0;
      for (var course in _courses[i]!) {
        double credit = double.tryParse(course['credits'] ?? '0') ?? 0;
        double grade = double.tryParse(course['grade'] ?? '0') ?? 0;
        semesterPoints += credit * grade;
        semesterCredits += credit;
      }
      double semesterGPA = semesterCredits > 0 ? semesterPoints / semesterCredits : 0;
      semesterGPAs[i] = semesterGPA;
      totalCGPA += semesterGPA * semesterCredits;
      totalCredits += semesterCredits;
    }
    double finalCGPA = totalCredits > 0 ? totalCGPA / totalCredits : 0;

    setState(() {
      _semesterGPAs = semesterGPAs;
      _finalCGPA = finalCGPA;
    });
  }

  void _editCourse(int semester, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCourseScreen(
          semester: semester,
          initialCourse: _courses[semester]![index],
        ),
      ),
    );
    if (result != null) {
      setState(() {
        _courses[semester]![index] = result;
        _semesterGPAs = null;
        _finalCGPA = null;
      });
    }
  }

  void _deleteCourse(int semester, int index) {
    setState(() {
      _courses[semester]!.removeAt(index);
      _semesterGPAs = null;
      _finalCGPA = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GPA & CGPA Calculator'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _askSemesterCount,
              child: Text('Enter Number of Semesters'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _numSemesters ?? 0,
                itemBuilder: (context, semester) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Semester ${semester + 1}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SizedBox(height: 10),
                          Table(
                            border: TableBorder.all(color: Color(0xFF5C4033).withOpacity(0.3)),
                            columnWidths: {
                              0: FlexColumnWidth(2),
                              1: FlexColumnWidth(1),
                              2: FlexColumnWidth(1),
                              3: FixedColumnWidth(80),
                            },
                            children: [
                              TableRow(
                                decoration: BoxDecoration(color: Color(0xFFD57A66).withOpacity(0.1)),
                                children: [
                                  Padding(padding: EdgeInsets.all(8.0), child: Text('Course', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold))),
                                  Padding(padding: EdgeInsets.all(8.0), child: Text('Credits', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold))),
                                  Padding(padding: EdgeInsets.all(8.0), child: Text('Grade', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold))),
                                  Padding(padding: EdgeInsets.all(8.0), child: Text('Actions', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold))),
                                ],
                              ),
                              for (int i = 0; i < _courses[semester]!.length; i++)
                                TableRow(
                                  children: [
                                    Padding(padding: EdgeInsets.all(8.0), child: Text(_courses[semester]![i]['course'] ?? 'N/A')),
                                    Padding(padding: EdgeInsets.all(8.0), child: Text(_courses[semester]![i]['credits'] ?? '0')),
                                    Padding(padding: EdgeInsets.all(8.0), child: Text(_courses[semester]![i]['grade'] ?? '0')),
                                    Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit, color: Color(0xFF8A4F2A), size: 20),
                                            onPressed: () => _editCourse(semester, i),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete, color: Color(0xFFBA3F1D), size: 20),
                                            onPressed: () => _deleteCourse(semester, i),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AddCourseScreen(semester: semester)),
                                );
                                if (result != null) {
                                  setState(() {
                                    _courses[semester]!.add(result);
                                    _semesterGPAs = null;
                                    _finalCGPA = null;
                                  });
                                }
                              },
                              icon: Icon(Icons.add, size: 18),
                              label: Text('Add Course'),
                              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFD57A66)),
                            ),
                          ),
                          if (_semesterGPAs != null && _semesterGPAs!.containsKey(semester)) ...[
                            SizedBox(height: 12),
                            Text(
                              'Semester GPA: ${_semesterGPAs![semester]!.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_finalCGPA != null) ...[
              SizedBox(height: 16),
              Text(
                'Final CGPA: ${_finalCGPA!.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _numSemesters != null ? _calculateGPAandCGPA : null,
              child: Text('Calculate GPA & CGPA'),
            ),
          ],
        ),
      ),
    );
  }
}

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
          children: [
            TextField(
              controller: _courseController,
              decoration: InputDecoration(
                labelText: 'Course Name',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _creditController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Credit Hours',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _gradeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Grade (4.0 scale)',
              ),
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