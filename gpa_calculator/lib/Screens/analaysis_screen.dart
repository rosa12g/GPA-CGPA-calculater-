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
    if (widget.grades.isEmpty) {
      setState(() {
        analysisResult = "Please enter at least one course grade.";
      });
      return;
    }

    setState(() {
      isLoading = true;
      analysisResult = null;
    });

    String? result;
    try {
      result = await GeminiService.analyzeCourses(widget.grades);
    } catch (e) {
      result = "Error occurred: $e";
    }

    setState(() {
      analysisResult = result ?? "No response from AI.";
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI Course Analysis", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFFCAB57), // Orange theme
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0XFFfff3e2)), // Background
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
                  color: Color(0xFFFCAB57),
                ),
              ),
              SizedBox(height: 15), // Increased spacing

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
                            color: Color(0xFF333333), 
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
                    backgroundColor: Color.fromARGB(255, 7, 7, 8),
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

              if (isLoading)
                Center(child: CircularProgressIndicator(color: Colors.deepPurple))
              else if (analysisResult != null)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "AI Suggestion:\n$analysisResult",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
