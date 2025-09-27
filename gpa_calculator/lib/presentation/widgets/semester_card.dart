import 'package:flutter/material.dart';
import '../../shared/models/course.dart';
import '../../core/constants/app_constants.dart';
import 'gradient_button.dart';

class SemesterCard extends StatelessWidget {
  final int semesterNumber;
  final List<Course> courses;
  final double? semesterGpa;
  final VoidCallback onAddCourse;
  final Function(int) onEditCourse;
  final Function(int) onDeleteCourse;

  const SemesterCard({
    super.key,
    required this.semesterNumber,
    required this.courses,
    required this.onAddCourse,
    required this.onEditCourse,
    required this.onDeleteCourse,
    this.semesterGpa,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.borderRadius)),
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Semester ${semesterNumber + 1}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent,
              ),
            ),
            const SizedBox(height: 12),
            if (courses.isNotEmpty) ...[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Table(
                  border: TableBorder.all(color: Colors.grey[700]!),
                  columnWidths: const {
                    0: FixedColumnWidth(100),
                    1: FixedColumnWidth(80),
                    2: FixedColumnWidth(80),
                    3: FixedColumnWidth(100),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey[800]),
                      children: const [
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
                    for (int i = 0; i < courses.length; i++)
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              courses[i].name,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              courses[i].credits.toString(),
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              courses[i].grade.toStringAsFixed(2),
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.cyanAccent, size: 20),
                                  onPressed: () => onEditCourse(i),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                                  onPressed: () => onDeleteCourse(i),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ] else ...[
              const Center(
                child: Text(
                  'No courses added yet',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: GradientButton(
                text: 'Add Course',
                onPressed: onAddCourse,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
            ),
            if (semesterGpa != null) ...[
              const SizedBox(height: 12),
              Text(
                'Semester GPA: ${semesterGpa!.toStringAsFixed(2)}',
                style: const TextStyle(
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
  }
}
