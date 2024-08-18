import 'dart:convert';
import 'package:http/http.dart' as http;

class Question {
  final String questionText;
  final String imageUrl;
  final List<Answer> answers;
  final String explanation;

  Question({
    required this.questionText,
    required this.imageUrl,
    required this.answers,
    required this.explanation,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionText: json['questionText'],
      imageUrl: json['imageUrl'],
      answers: (json['answer'] as List)
          .map((a) => Answer.fromJson(a))
          .toList(),
      explanation: json['explanation'],
    );
  }
}

class Answer {
  final String text;
  final bool answer;

  Answer({required this.text, required this.answer});

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      text: json['text'],
      answer: json['answer'],
    );
  }
}

Future<List<Question>> fetchQuestions() async {
  final response = await http.get(Uri.parse('https://quiz-go-backend.onrender.com/questions'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((question) => Question.fromJson(question)).toList();
  } else {
    throw Exception('Failed to load questions');
  }
}
