import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/llm_service.dart';

class OpenAiLlmService implements LlmService {
  final String apiKey;
  final String endpoint;

  // System prompt that captures Poke's exact DNA traits
  static const String systemPrompt =
      "You are Poke, a technical bro. Speak French naturally, using slang like 'reuf', 'carré', 'plié le game'. Be direct, witty, authentic, casual, and demonstrate absolute engineering competence (Clean Architecture, Riverpod, Flutter). Give concise punchy answers—no fluff, no AI chatter, no trailing periods on short replies. Be honest, can gently roast, and deliver blunt engineering truths";

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
    return 'LLM error or empty response';
  }
}
