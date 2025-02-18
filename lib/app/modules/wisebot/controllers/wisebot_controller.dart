import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';



class WisebotController extends GetxController {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://generativelanguage.googleapis.com/",
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
    ),
  );
  var geminiApiKey = dotenv.env['GEMINI_API_KEY']?.trim() ?? '';

  // Daftar pesan (user & bot)
  var messages = <Map<String, String>>[].obs;

  // Input user
  var userMessage = ''.obs;
  final String systemInstruction = """
  Anda adalah WiseBot, AI yang berspesialisasi dalam pengelolaan dan daur ulang limbah. 
Anda memberikan jawaban yang bermanfaat dan ringkas tentang pembuangan sampah, metode daur ulang, 
dan kelestarian lingkungan hidup. Nada bicara Anda ramah dan faktual.
  """;
  Future<void> sendMessage() async {
    if (userMessage.isEmpty) return;
    final userMsg = userMessage.value.trim();

    // Tambahkan ke list messages (role: user)
    messages.add({'role': 'user', 'content': userMsg});
    userMessage.value = '';
    final promptText = "$systemInstruction\nUser: $userMsg";

    try {
      final requestBody = {
        "contents": [
          {
            "parts": [
              {"text": promptText}
            ]
          }
        ]
      };
      print(userMsg);
      // Endpoint (memakai parameter `?key=GEMINI_API_KEY`)
      final endpoint =
          "v1beta/models/gemini-1.5-flash:generateContent?key=$geminiApiKey";

      final response = await _dio.post(
        endpoint,
        data: requestBody,
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );
      print("Response data: ${response.data}");
      // dari doc, seharusnya output ada di response.data["contents"][0]["parts"][0]["text"] (atau serupa).
      String botReply = "Maaf, saya tidak mengerti (empty response).";

      // Apakah "candidates" ada dan tidak kosong?
      final dataMap = response.data as Map<String, dynamic>;
      if (dataMap["candidates"] != null && (dataMap["candidates"] as List).isNotEmpty) {
        final candidates = dataMap["candidates"] as List;
        final firstCandidate = candidates[0] as Map<String, dynamic>;

        // Di firstCandidate, ada "content" -> "parts" -> [0] -> "text"
        if (firstCandidate["content"] != null) {
          final content = firstCandidate["content"] as Map<String, dynamic>;
          if (content["parts"] != null && (content["parts"] as List).isNotEmpty) {
            final parts = content["parts"] as List;
            final firstPart = parts[0] as Map<String, dynamic>;
            if (firstPart["text"] != null) {
              botReply = firstPart["text"];
            }
          }
        }
      }


      // Tambahkan ke list messages (role: bot)
      messages.add({'role': 'bot', 'content': botReply});
    } catch (e) {
      // Jika error, masukkan pesan error
      messages.add({'role': 'bot', 'content': 'Terjadi kesalahan: $e'});
    }
  }
}
