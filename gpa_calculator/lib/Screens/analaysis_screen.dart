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
        backgroundColor: Colors.deepPurple, // Deep purple app bar
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade50, Colors.white], // Gradient background
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your Courses:",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple, // Deep purple text
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
                        title: Text(
                          e.key,
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        trailing: Text(
                          e.value.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.deepPurple, // Deep purple for grades
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
                    backgroundColor: Colors.deepPurple, // Deep purple button
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
                  ? Center(child: CircularProgressIndicator(color: Colors.deepPurple)) // Deep purple loading indicator
                  : analysisResult != null
                      ? Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "AI Suggestion:\n$analysisResult",
                              style: TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                          ),
                        )
                      : Container(),
            ],
          ),
        ),
      ),
    );
  }
}