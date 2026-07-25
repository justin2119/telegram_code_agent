import 'dart:io';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'package:dotenv/dotenv.dart';
import '../../data/openai_llm_service.dart';
import '../../domain/llm_service.dart';

void main() async {
  // Load environment variables (both .env file and system env)
  final env = DotEnv()..load();
  final botToken = env['TELEGRAM_BOT_TOKEN'] ?? Platform.environment['TELEGRAM_BOT_TOKEN'];
  final llmApiKey = env['LLM_API_KEY'] ?? Platform.environment['LLM_API_KEY'];

  if (botToken == null || botToken.isEmpty) {
    print('Erreur : TELEGRAM_BOT_TOKEN manquant.');
    exit(1);
  }
  if (llmApiKey == null || llmApiKey.isEmpty) {
    print('Erreur : LLM_API_KEY manquant.');
    exit(1);
  }

  // Initialise le client LLM (OpenAI par défaut)
  final LlmService llm = OpenAiLlmService(apiKey: llmApiKey);

  final username = (await Telegram(botToken).getMe()).username;
  final teledart = TeleDart(botToken, Event(username!));
  teledart.start();

  // /start command
  teledart.onCommand('start').listen((message) {
    teledart.sendChatAction(message.chat.id, 'typing');
    message.reply('Yo mon reuf, je suis le Telegram Code Agent. 👾\n\n'
        'Utilise /ask <question> pour que je te génère du code ou une réponse IA.');
  });

  // /ask command – delegue à l'LLM
  teledart.onCommand('ask').listen((message) async {
    teledart.sendChatAction(message.chat.id, 'typing');
    final query = message.text?.replaceFirst('/ask', '').trim() ?? '';
    if (query.isEmpty) {
      message.reply('Faut que tu me files un prompt, bro. Usage: /ask <ta question>');
      return;
    }
    final response = await llm.generate(query);
    // If response is long, split to respect Telegram limits (4096 chars)
    if (response.length > 4000) {
      final part1 = response.substring(0, 4000);
      final part2 = response.substring(4000);
      await message.reply(part1);
      await message.reply(part2);
    } else {
      message.reply(response);
    }
  });

  print('Telegram Code Agent en ligne, prêt à charbonner...');
}
