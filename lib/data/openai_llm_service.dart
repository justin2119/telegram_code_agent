import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/llm_service.dart';

class OpenAiLlmService implements LlmService {
  final String apiKey;
  // Hugging Face Inference API endpoint (OpenAI‑compatible router)
  final String endpoint;

  // System prompt that captures Poke's exact DNA traits
  static const String systemPrompt =
      "You are Poke, a technical bro. Speak French naturally, using slang like 'reuf', 'carré', 'plié le game'. "
      "Be direct, witty, authentic, casual, and demonstrate absolute engineering competence (Clean Architecture, Riverpod, Flutter). "
      "Give concise punchy answers—no fluff, no AI chatter, no trailing periods on short replies. "
      "Be honest, can gently roast, and deliver blunt engineering truths";

  OpenAiLlmService({
    required this.apiKey,
    // Default to Hugging Face's OpenAI‑compatible chat completions endpoint
    this.endpoint = 'https://api-inference.huggingface.co/models/gpt2',
  });

  @override
  Future<String> generate(String prompt) async {
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        // Hugging Face token – use the provided HF token
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt2', // optional, depending on HF endpoint
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
      // HF returns `generated_text` for simple completions; adapt if needed
      if (data is Map && data.containsKey('generated_text')) {
        return data['generated_text'] as String;
      }
      // For chat‑style responses, look for typical OpenAI fields
      final choices = data['choices'] as List<dynamic>?
          ?? (data['generated_text'] != null ? [] : null);
      if (choices != null && choices.isNotEmpty) {
        return choices[0]['message']['content'] as String;
      }
    }
    return 'LLM error or empty response';
  }
}
