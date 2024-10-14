import 'package:flutter/material.dart';
import 'chat_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Información del Proyecto")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Universidad: XYZ", style: TextStyle(fontSize: 18)),
            Text("Carrera: Ingeniería de Software", style: TextStyle(fontSize: 18)),
            Text("Materia: Desarrollo de Apps", style: TextStyle(fontSize: 18)),
            Text("Grupo: 1A", style: TextStyle(fontSize: 18)),
            Text("Alumno: Nombre del Alumno", style: TextStyle(fontSize: 18)),
            Text("Matrícula: 12345678", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreen()),
                );
              },
              child: Text("Ir al Chat"),
            ),
          ],
        ),
      ),
    );
  }
}
