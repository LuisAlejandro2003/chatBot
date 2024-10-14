import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ChatService {
  // Obtener historial de mensajes por usuario
  static Future<List<Map<String, dynamic>>> getChatHistory(String userId) async {
    final response = await http.get(Uri.parse('http://192.168.156.119:3000/messages/$userId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception("Error al obtener el historial de mensajes");
    }
  }

  // Guardar un nuevo mensaje en MongoDB
  static Future<void> saveMessage(String userId, String role, String content) async {
    await http.post(
      Uri.parse('http://192.168.156.119:3000/messages'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'role': role,
        'content': content,
      }),
    );
  }

  // Obtener respuesta del bot desde Gemini y guardar en la base de datos
  static Future<String> getBotResponseWithHistory(String userId, String message) async {
    try {
      // Hacer petición al modelo de Gemini
      final response = await http.post(
        Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=AIzaSyAUnzZrXiZCdjavNzJvV5gjuxyBBkImrrA'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "contents": [
            {"parts": [{"text": message}]}
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data != null && data['candidates'] != null && data['candidates'].isNotEmpty) {
          // Extraer la respuesta del bot
          String botResponse = data['candidates'][0]['content']['parts'][0]['text'] ?? 'Respuesta vacía del modelo';

          // Guardar mensaje del usuario y del bot en la base de datos
          await saveMessage(userId, 'user', message);
          await saveMessage(userId, 'bot', botResponse);

          return botResponse;
        } else {
          return 'Formato de respuesta inesperado.';
        }
      } else {
        print('Error en la respuesta: ${response.statusCode} - ${response.body}');
        return 'Error al conectar con el bot.';
      }
    } catch (e) {
      print("Error de conexión: $e");
      return 'Error al conectar con el bot.';
    }
  }
}
