import 'package:flutter/material.dart';
import 'add_course_screen.dart';
import 'package:gpa_calculator/logics/Calculations.dart';
import 'analaysis_screen.dart'; // Import the AnalysisScreen

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
            decoration: InputDecoration(hintText: 'Enter number of semesters'),
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
              child: Text('OK', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            ),
          ],
        );
      },
    );
  }

  void _calculateGPAandCGPA() {
    final result = GPAandCGPACalculator.calculateGPAandCGPA(_numSemesters, _courses);
    setState(() {
      _semesterGPAs = result['semesterGPAs'];
      _finalCGPA = result['finalCGPA'];
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

  void _navigateToAnalysis() {
    // Collect grades for each course and pass it to the analysis screen
    Map<String, double> grades = {};
    _courses.forEach((semester, courses) {
      for (var course in courses) {
        double grade = double.tryParse(course['grade'] ?? '0') ?? 0;
        grades[course['course'] ?? 'Unknown Course'] = grade;
      }
    });

    // Navigate to the analysis screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnalysisScreen(grades: grades),
      ),
    );
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
                          LayoutBuilder(
                            builder: (context, constraints) {
                              // Dynamically adjust column widths based on available space
                              double availableWidth = constraints.maxWidth;
                              return Table(
                                border: TableBorder.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3)),
                                columnWidths: {
                                  0: FixedColumnWidth(availableWidth * 0.4), // 40% for Course
                                  1: FixedColumnWidth(availableWidth * 0.2), // 20% for Credits
                                  2: FixedColumnWidth(availableWidth * 0.2), // 20% for Grade
                                  3: FixedColumnWidth(availableWidth * 0.2), // 20% for Actions
                                },
                                children: [
                                  TableRow(
                                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary.withOpacity(0.1)),
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Course', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Credits', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Grade', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Actions', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                                      ),
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
                                                icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary, size: 20),
                                                onPressed: () => _editCourse(semester, i),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error, size: 20),
                                                onPressed: () => _deleteCourse(semester, i),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              );
                            },
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
                              style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary),
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
            SizedBox(height: 16),
            // New Analyze button
            ElevatedButton(
              onPressed: _finalCGPA != null ? _navigateToAnalysis : null,
              child: Text('Analyze My Weaknesses'),
            ),
          ],
        ),
      ),
    );
  }
}