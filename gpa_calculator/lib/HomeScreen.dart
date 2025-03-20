import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: HomeScreen()));
}

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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text('Number of Semesters', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
          content: TextField(
            controller: semesterController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter number of semesters',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Colors.grey[100],
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
              child: Text('OK', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GPA & CGPA Calculator', style: TextStyle(fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey[100]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: _askSemesterCount,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                child: Text('Enter Number of Semesters', style: TextStyle(fontSize: 16)),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _numSemesters ?? 0,
                  itemBuilder: (context, semester) {
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Semester ${semester + 1}',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                            ),
                            SizedBox(height: 10),
                            Table(
                              border: TableBorder.all(color: Colors.grey),
                              columnWidths: {
                                0: FlexColumnWidth(2),
                                1: FlexColumnWidth(1),
                                2: FlexColumnWidth(1),
                              },
                              children: [
                                TableRow(
                                  decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.1)),
                                  children: [
                                    Padding(padding: EdgeInsets.all(8.0), child: Text('Course', style: TextStyle(fontWeight: FontWeight.bold))),
                                    Padding(padding: EdgeInsets.all(8.0), child: Text('Credits', style: TextStyle(fontWeight: FontWeight.bold))),
                                    Padding(padding: EdgeInsets.all(8.0), child: Text('Grade', style: TextStyle(fontWeight: FontWeight.bold))),
                                  ],
                                ),
                                for (var course in _courses[semester]!)
                                  TableRow(
                                    children: [
                                      Padding(padding: EdgeInsets.all(8.0), child: Text(course['course'] ?? 'N/A')),
                                      Padding(padding: EdgeInsets.all(8.0), child: Text(course['credits'] ?? '0')),
                                      Padding(padding: EdgeInsets.all(8.0), child: Text(course['grade'] ?? '0')),
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
                                    });
                                  }
                                },
                                icon: Icon(Icons.add, size: 18),
                                label: Text('Add Course'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                            if (_semesterGPAs != null && _semesterGPAs!.containsKey(semester)) ...[
                              SizedBox(height: 12),
                              Text(
                                'Semester GPA: ${_semesterGPAs![semester]!.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                ),
              ],
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _numSemesters != null ? _calculateGPAandCGPA : null,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                child: Text('Calculate GPA & CGPA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddCourseScreen extends StatefulWidget {
  final int semester;

  AddCourseScreen({required this.semester});

  @override
  _AddCourseScreenState createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _courseController = TextEditingController();
  final _creditController = TextEditingController();
  final _gradeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Course - Semester ${widget.semester + 1}', style: TextStyle(fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
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
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _creditController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Credit Hours',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _gradeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Grade (4.0 scale)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey[100],
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
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
              child: Text('Save Course', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}