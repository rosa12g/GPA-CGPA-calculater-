import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String apiKey = "AIzaSyDTyk8ZXKpqi1fw72sSnO7MBLHC7308ozs"; 
  static const String baseUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateText";

  static Future<String?> analyzeCourses(Map<String, double> grades) async {
    String prompt = _generatePrompt(grades);

    final response = await http.post(
      Uri.parse("$baseUrl?key=$apiKey"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "prompt": {"text": prompt},
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["candidates"]?[0]["output"] ?? "No suggestion available.";
    } else {
      return "Error: ${response.body}";
    }
  }

  static String _generatePrompt(Map<String, double> grades) {
    return """
    The user has taken the following courses and their corresponding grades:

    ${grades.entries.map((e) => "- ${e.key}: ${e.value}").join("\n")}

    Based on the grades, analyze which subjects the user is weak in and suggest ways to improve. Also, recommend related knowledge areas to focus on.
    """;
  }
}
