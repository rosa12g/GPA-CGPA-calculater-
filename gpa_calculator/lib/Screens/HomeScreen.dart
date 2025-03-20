import 'package:flutter/material.dart';
import 'package:gpa_calculator/screens/analysis_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GPA Calculator"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome!", style: Theme.of(context).textTheme.displayMedium),
            SizedBox(height: 10),
            Text("Calculate your GPA and plan your academic goals.", style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildFeatureCard(
                    context,
                    icon: Icons.calculate,
                    title: "GPA Calculator",
                    onTap: () {
                      // Navigate to GPA Calculator Screen
                    },
                  ),
                  _buildFeatureCard(
                    context,
                    icon: Icons.analytics,
                    title: "AI Analysis",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnalysisScreen(grades: {"Mathematics": 2.5, "Physics": 3.0, "Programming": 1.8}),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
              SizedBox(height: 10),
              Text(title, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
