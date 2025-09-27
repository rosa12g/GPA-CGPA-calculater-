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
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
      analysisResult = null;
    });

    String? result;
    try {
      print("Calling Gemini API with grades: ${widget.grades}");
      result = await GeminiService.analyzeCourses(widget.grades);
      print("API result: $result");
    } catch (e) {
      result = "Error occurred: $e";
      print("Error occurred: $e");
    }

    setState(() {
      analysisResult = result ?? "No response from AI.";
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "AI Performance Analysis",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
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
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: true,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Courses:",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent,
                        ),
                      ),
                      SizedBox(height: 20),
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        color: Colors.grey[850],
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: widget.grades.entries.map(
                              (e) => ListTile(
                                title: Text(
                                  e.key,
                                  style: TextStyle(fontSize: 16, color: Colors.white70),
                                ),
                                trailing: Text(
                                  e.value.toStringAsFixed(2),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.greenAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ).toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: analyzePerformance,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            elevation: 8,
                          ),
                          child: Text(
                            "Analyze My Weaknesses",
                            style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      if (isLoading)
                        Center(
                          child: CircularProgressIndicator(color: Colors.cyanAccent),
                        )
                      else if (analysisResult != null)
                        Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          color: Colors.grey[850],
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "AI Insights:",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.cyanAccent,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  analysisResult!,
                                  style: TextStyle(fontSize: 16, color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ),
                      SizedBox(height: 20),
                    ],
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
