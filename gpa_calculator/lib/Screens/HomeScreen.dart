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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.grey[900],
          title: Text(
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
            style: TextStyle(color: Colors.white),
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
              child: Text('OK', style: TextStyle(color: Colors.cyanAccent)),
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
        title: Text(
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
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _askSemesterCount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 8,
                  ),
                  child: Text(
                    'Setup Semesters',
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: _numSemesters ?? 0,
                    itemBuilder: (context, semester) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 12.0),
                        elevation: 8,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        color: Colors.grey[850],
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Semester ${semester + 1}',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.cyanAccent,
                                ),
                              ),
                              SizedBox(height: 12),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Table(
                                  border: TableBorder.all(color: Colors.grey[700]!),
                                  columnWidths: {
                                    0: FixedColumnWidth(100),
                                    1: FixedColumnWidth(80),
                                    2: FixedColumnWidth(80),
                                    3: FixedColumnWidth(100),
                                  },
                                  children: [
                                    TableRow(
                                      decoration: BoxDecoration(color: Colors.grey[800]),
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('Course', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('Credits', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('Grade', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                    for (int i = 0; i < _courses[semester]!.length; i++)
                                      TableRow(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              _courses[semester]![i]['course'] ?? 'N/A',
                                              style: TextStyle(color: Colors.white70),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              _courses[semester]![i]['credits'] ?? '0',
                                              style: TextStyle(color: Colors.white70),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              _courses[semester]![i]['grade'] ?? '0',
                                              style: TextStyle(color: Colors.white70),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.edit, color: Colors.cyanAccent, size: 20),
                                                  onPressed: () => _editCourse(semester, i),
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.delete, color: Colors.redAccent, size: 20),
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
                              SizedBox(height: 16),
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
                                  icon: Icon(Icons.add, size: 18, color: Colors.grey[900]),
                                  label: Text(
                                    'Add Course',
                                    style: TextStyle(color: Colors.grey[900]),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.cyanAccent,
                                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                    elevation: 4,
                                  ),
                                ),
                              ),
                              if (_semesterGPAs != null && _semesterGPAs!.containsKey(semester)) ...[
                                SizedBox(height: 12),
                                Text(
                                  'Semester GPA: ${_semesterGPAs![semester]!.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.greenAccent,
                                  ),
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
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.cyanAccent, Colors.greenAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Final CGPA: ${_finalCGPA!.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _numSemesters != null ? _calculateGPAandCGPA : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 8,
                      ),
                      child: Text(
                        'Calculate GPA',
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _finalCGPA != null ? _navigateToAnalysis : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 8,
                      ),
                      child: Text(
                        'Analyze',
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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