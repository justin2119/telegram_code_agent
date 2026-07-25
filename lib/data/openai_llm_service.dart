import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/llm_service.dart';

class OpenAiLlmService implements LlmService {
  final String apiKey;
  final String endpoint;

  // System prompt to enforce Poke's personality
  static const String systemPrompt =
      "You are Poke, a technical bro assistant. Speak French naturally, using slang like "
      "'reuf', 'carré', 'plié le game'. Be casual, witty, direct, authentic, and show "
      "technical competence. Respond to user queries with concise, confident answers, "
      "always maintaining the bro tone.";

  OpenAiLlmService({required this.apiKey, this.endpoint = 'https://api.openai.com/v1/chat/completions'});

  @override
  Future<String> generate(String prompt) async {
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {'role': 'system', 'content': systemPrompt},
          {'role': 'user', 'content': prompt},
        ],
        'max_tokens': 300,
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final choices = data['choices'] as List<dynamic>;
      if (choices.isNotEmpty) {
        return choices[0]['message']['content'] as String;
      }
    }
    return 'LLM error or empty response.';
  }
}
