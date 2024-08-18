import 'package:flutter/material.dart';
import 'quiz_screen.dart'; // Import the quiz screen

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome to the Quiz App',
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[50],
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QuizScreen()),
            );
          },
          child: Text('Start Quiz', style: TextStyle(fontSize: 20.0)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // Updated
            foregroundColor: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
      ),
    );
  }
}
