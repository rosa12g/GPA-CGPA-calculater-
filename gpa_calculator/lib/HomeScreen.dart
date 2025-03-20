import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<TextEditingController> _courseControllers = [];
  final List<TextEditingController> _creditControllers = [];
  final List<TextEditingController> _gradeControllers = [];

  void _addCourse() {
    setState(() {
      _courseControllers.add(TextEditingController());
      _creditControllers.add(TextEditingController());
      _gradeControllers.add(TextEditingController());
    });
  }

  void _calculateGPA() {
    double totalPoints = 0;
    double totalCredits = 0;
    for (int i = 0; i < _creditControllers.length; i++) {
      double credit = double.tryParse(_creditControllers[i].text) ?? 0;
      double grade = double.tryParse(_gradeControllers[i].text) ?? 0;
      totalPoints += credit * grade;
      totalCredits += credit;
    }
    double gpa = totalCredits > 0 ? totalPoints / totalCredits : 0;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Your GPA'),
        content: Text('Your GPA is: ${gpa.toStringAsFixed(2)}'),
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
            Expanded(
              child: ListView.builder(
                itemCount: _courseControllers.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: _courseControllers[index],
                            decoration: InputDecoration(labelText: 'Course Name'),
                          ),
                          TextField(
                            controller: _creditControllers[index],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: 'Credit Hours'),
                          ),
                          TextField(
                            controller: _gradeControllers[index],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: 'Grade (4.0 scale)'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _addCourse,
                  child: Text('Add Course'),
                ),
                ElevatedButton(
                  onPressed: _calculateGPA,
                  child: Text('Calculate GPA'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}