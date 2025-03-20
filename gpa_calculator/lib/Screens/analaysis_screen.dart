import 'package:flutter/material.dart';
import '../services/gemini_service.dart';

class AnalysisScreen extends StatefulWidget {
  final Map<String, double> grades;

  AnalysisScreen({required this.grades});

  @override
  _AnalysisScreenState createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  String? analysisResult;
  bool isLoading = false;

  void analyzePerformance() async {
    setState(() => isLoading = true);
    String? result = await GeminiService.analyzeCourses(widget.grades);
    setState(() {
      analysisResult = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI Course Analysis")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Your Courses:", style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            ...widget.grades.entries.map(
              (e) => Text("${e.key}: ${e.value}", style: Theme.of(context).textTheme.bodyLarge),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: analyzePerformance,
              child: Text("Analyze My Weaknesses"),
            ),
            SizedBox(height: 20),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : analysisResult != null
                    ? Text("AI Suggestion:\n$analysisResult", style: Theme.of(context).textTheme.bodyLarge)
                    : Container(),
          ],
        ),
      ),
    );
  }
}
