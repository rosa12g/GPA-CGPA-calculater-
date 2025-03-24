import 'package:flutter/material.dart';
import 'add_course_screen.dart';
import 'package:gpa_calculator/logics/Calculations.dart';
import 'analaysis_screen.dart';

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
          backgroundColor: Color.fromARGB(255, 255, 244, 232),
          title: Text('Add the number of semester', 
                   style: TextStyle(fontSize: 20, 
                   fontWeight: FontWeight.bold,
                    color: Color(0xff222222)
                    )
                    ),
          content: TextField(
            controller: semesterController,
            keyboardType: TextInputType.number,
          
            decoration: InputDecoration(
              hintText: 'Enter number of semesters',
              fillColor:   Color.fromARGB(255, 233, 230, 228),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
              child: Text('OK', style: TextStyle(color: Color(0xff222222))),
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
    Map<String, double> grades = {};
    _courses.forEach((semester, courses) {
      for (var course in courses) {
        double grade = double.tryParse(course['grade'] ?? '0') ?? 0;
        grades[course['course'] ?? 'Unknown Course'] = grade;
      }
    });

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
        title: Text('GradeMaster', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color:Color(0xFF222222))),
        backgroundColor:Color(0xFFFCAB57),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0XFFfff3e2),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: _askSemesterCount,
                style: ElevatedButton.styleFrom(
                   backgroundColor:Color(0xFF222222),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Set Up Your Semesters', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _numSemesters ?? 0,
                  itemBuilder: (context, semester) {
                    //card for table
                    return Card(
                     
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color:  Color(0xFFFEC674),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Semester ${semester + 1}',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff222222)),
                            ),
                            SizedBox(height: 10),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal, //scroll
                              child: Table( //table added
                                border: TableBorder.all(color: Colors.black),
                                columnWidths: {
                                  0: FixedColumnWidth(80), // Course
                                  1: FixedColumnWidth(80),  // Credits
                                  2: FixedColumnWidth(80),  // Grade
                                  3: FixedColumnWidth(80),  // Actions
                                },
                                children: [
                                  TableRow(
                                    decoration: BoxDecoration(color:  Color(0XFFfff3e2)),
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Course', style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Credits', style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Grade', style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
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
                                                icon: Icon(Icons.edit, color: Colors.deepPurple, size: 20),
                                                onPressed: () => _editCourse(semester, i),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.delete, color: Colors.red, size: 20),
                                                onPressed: () => _deleteCourse(semester, i),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
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
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF222222),
                                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                            if (_semesterGPAs != null && _semesterGPAs!.containsKey(semester)) ...[
                              SizedBox(height: 12),
                              Text(
                                'Semester GPA: ${_semesterGPAs![semester]!.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  'Your Final CGPA: ${_finalCGPA!.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color:  Color(0xFFFCAB57),)
                ),
              ],
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _numSemesters != null ? _calculateGPAandCGPA : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF222222),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Calculate GPA & CGPA', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _finalCGPA != null ? _navigateToAnalysis : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF222222),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Analyze My Performance', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}