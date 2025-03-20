import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? _numSemesters;
  final Map<int, List<TextEditingController>> _courseControllers = {};
  final Map<int, List<TextEditingController>> _creditControllers = {};
  final Map<int, List<TextEditingController>> _gradeControllers = {};

  void _askSemesterCount() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController semesterController = TextEditingController();
        return AlertDialog(
          title: Text('Enter Number of Semesters'),
          content: TextField(
            controller: semesterController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Number of semesters'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                int? num = int.tryParse(semesterController.text);
                if (num != null && num > 0) {
                  setState(() {
                    _numSemesters = num;
                    for (int i = 0; i < num; i++) {
                      _courseControllers[i] = [];
                      _creditControllers[i] = [];
                      _gradeControllers[i] = [];
                    }
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _addCourse(int semester) {
    setState(() {
      _courseControllers[semester]?.add(TextEditingController());
      _creditControllers[semester]?.add(TextEditingController());
      _gradeControllers[semester]?.add(TextEditingController());
    });
  }

  void _calculateGPAandCGPA() {
    double totalCGPA = 0;
    double totalCredits = 0;
    Map<int, double> semesterGPAs = {};

    for (int i = 0; i < (_numSemesters ?? 0); i++) {
      double semesterPoints = 0;
      double semesterCredits = 0;
      for (int j = 0; j < _creditControllers[i]!.length; j++) {
        double credit = double.tryParse(_creditControllers[i]![j].text) ?? 0;
        double grade = double.tryParse(_gradeControllers[i]![j].text) ?? 0;
        semesterPoints += credit * grade;
        semesterCredits += credit;
      }
      double semesterGPA = semesterCredits > 0 ? semesterPoints / semesterCredits : 0;
      semesterGPAs[i] = semesterGPA;
      totalCGPA += semesterGPA * semesterCredits;
      totalCredits += semesterCredits;
    }
    double finalCGPA = totalCredits > 0 ? totalCGPA / totalCredits : 0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('GPA & CGPA Results'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...semesterGPAs.entries.map((e) => Text('Semester ${e.key + 1} GPA: ${e.value.toStringAsFixed(2)}')),
            SizedBox(height: 10),
            Text('Final CGPA: ${finalCGPA.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GPA & CGPA Calculator')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _askSemesterCount,
              child: Text('Enter Number of Semesters'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _numSemesters ?? 0,
                itemBuilder: (context, semester) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Semester ${semester + 1}', style: TextStyle(fontWeight: FontWeight.bold)),
                          ...List.generate(_courseControllers[semester]?.length ?? 0, (index) {
                            return Column(
                              children: [
                                TextField(
                                  controller: _courseControllers[semester]![index],
                                  decoration: InputDecoration(labelText: 'Course Name'),
                                ),
                                TextField(
                                  controller: _creditControllers[semester]![index],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(labelText: 'Credit Hours'),
                                ),
                                TextField(
                                  controller: _gradeControllers[semester]![index],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(labelText: 'Grade (4.0 scale)'),
                                ),
                              ],
                            );
                          }),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => _addCourse(semester),
                            child: Text('Add Course'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _calculateGPAandCGPA,
              child: Text('Calculate GPA & CGPA'),
            ),
          ],
        ),
      ),
    );
  }
}
