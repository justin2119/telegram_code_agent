abstract class LlmService {
  /// Generate a response from the LLM given a [prompt].
  /// Returns the raw string response.
  Future<String> generate(String prompt);
}
