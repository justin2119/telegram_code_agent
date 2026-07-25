import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/llm_service.dart';

class OpenAiLlmService implements LlmService {
  final String apiKey;
  final String endpoint;

  OpenAiLlmService({required this.apiKey, this.endpoint = 'https://api.openai.com/v1/chat/completions'});

  @override
  Future<String> generate(String prompt) async {
    // Simple placeholder implementation – you can adapt to any LLM provider.
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
        'max_tokens': 150,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final choices = data['choices'] as List<dynamic>;
      if (choices.isNotEmpty) {
        return choices[0]['message']['content'] as String;
      }
    }
    // Fallback if anything goes wrong
    return 'LLM error or empty response.';
  }
}
