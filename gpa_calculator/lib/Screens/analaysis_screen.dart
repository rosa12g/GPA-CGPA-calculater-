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
      appBar: AppBar(
        title: Text("AI Course Analysis", style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        // Add this to handle overflow
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Courses:",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: widget.grades.entries.map(
                    (e) => ListTile(
                      title: Text(e.key, style: Theme.of(context).textTheme.bodyLarge),
                      trailing: Text(
                        e.value.toStringAsFixed(2),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ).toList(),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: analyzePerformance,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  "Analyze My Weaknesses",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 20),
            isLoading
                ? Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary))
                : analysisResult != null
                    ? Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "AI Suggestion:\n$analysisResult",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      )
                    : Container(),
          ],
        ),
      ),
    );
  }
}