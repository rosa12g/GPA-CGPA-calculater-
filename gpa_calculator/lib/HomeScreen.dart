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
                      _courseControllers[i] = [];
                      _creditControllers[i] = [];
                      _gradeControllers[i] = [];
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text('GPA & CGPA Results', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...semesterGPAs.entries.map((e) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      'Semester ${e.key + 1} GPA: ${e.value.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                    ),
                  )),
              SizedBox(height: 12),
              Text(
                'Final CGPA: ${finalCGPA.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
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
                            ...List.generate(_courseControllers[semester]?.length ?? 0, (index) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: _courseControllers[semester]![index],
                                      decoration: InputDecoration(
                                        labelText: 'Course Name',
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                        filled: true,
                                        fillColor: Colors.grey[100],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: _creditControllers[semester]![index],
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: 'Credit Hours',
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                              filled: true,
                                              fillColor: Colors.grey[100],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: TextField(
                                            controller: _gradeControllers[semester]![index],
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: 'Grade (4.0)',
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                              filled: true,
                                              fillColor: Colors.grey[100],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                            SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: () => _addCourse(semester),
                                icon: Icon(Icons.add, size: 18),
                                label: Text('Add Course'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _calculateGPAandCGPA,
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

