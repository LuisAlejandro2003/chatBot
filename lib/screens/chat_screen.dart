import 'package:flutter/material.dart';
import '../widgets/message_bubble.dart';
import '../services/chat_service.dart';
import '../models/message.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _controller = TextEditingController();
  List<Message> _messages = [];
  final String userId = '12345'; // Cambia este valor para identificar al usuario

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  void _loadChatHistory() async {
    try {
      List<Map<String, dynamic>> messages = await ChatService.getChatHistory(userId);
      setState(() {
        _messages = messages.map((msg) => Message(
          content: msg['content'],
          isUser: msg['role'] == 'user'
        )).toList();
      });
    } catch (e) {
      print("Error al cargar el historial de chat: $e");
    }
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(Message(content: text, isUser: true));
    });

    // Guardar mensaje del usuario
    await ChatService.saveMessage(userId, 'user', text);

    // Obtener y guardar respuesta del bot
    String response = await ChatService.getBotResponseWithHistory(userId, text);

    setState(() {
      _messages.add(Message(content: response, isUser: false));
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat con el Bot")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return MessageBubble(
                  content: message.content,
                  isUser: message.isUser,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
