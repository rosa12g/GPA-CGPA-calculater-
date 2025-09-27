import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';

abstract class AnalysisRemoteDataSource {
  Future<String> analyzeCourses(Map<String, double> grades);
}

class AnalysisRemoteDataSourceImpl implements AnalysisRemoteDataSource {
  final http.Client client;

  AnalysisRemoteDataSourceImpl({required this.client});

  @override
  Future<String> analyzeCourses(Map<String, double> grades) async {
    try {
      await dotenv.load();
      final apiKey = dotenv.env[AppConstants.geminiApiKey];

      if (apiKey == null) {
        throw ServerException("GEMINI_API_KEY is not set in the .env file.");
      }

      final prompt = _generatePrompt(grades);
      print("Generated prompt: $prompt");

      final response = await client.post(
        Uri.parse("${AppConstants.geminiBaseUrl}?key=$apiKey"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("API Response: $data");

        if (data["candidates"] != null && data["candidates"].isNotEmpty) {
          return data["candidates"][0]["content"]["parts"][0]["text"] ?? "No suggestion available.";
        } else {
          return "No suggestion available.";
        }
      } else {
        print("API Error: ${response.statusCode} - ${response.body}");
        throw ServerException("API Error: ${response.statusCode} - ${response.body}");
      }
    } on http.ClientException {
      throw NetworkException("Network error occurred");
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException("Unexpected error: $e");
    }
  }

  String _generatePrompt(Map<String, double> grades) {
    return """
    The user has taken the following courses and their corresponding grades:

    ${grades.entries.map((e) => "- ${e.key}: ${e.value}").join("\n")}

    Based on the grades, analyze which subjects the user is weak in and suggest ways to improve. Also, recommend related knowledge areas to focus on.
    """;
  }
}
