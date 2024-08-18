import 'package:flutter/material.dart';
import 'api_service.dart';
import 'score_screen.dart';

class QuizScreen extends StatefulWidget {
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<List<Question>> futureQuestions;
  int currentQuestionIndex = 0;
  int score = 0;
  bool? isCorrect;
  bool showExplanation = false;

  @override
  void initState() {
    super.initState();
    refreshQuestions();
  }

  Future<void> refreshQuestions() async {
    setState(() {
      futureQuestions = fetchQuestions();
      currentQuestionIndex = 0;
      score = 0;
      isCorrect = null;
      showExplanation = false;
    });
  }

  void checkAnswer(String userAnswer) {
  futureQuestions.then((questions) {
    final currentQuestion = questions[currentQuestionIndex];
    final correctAnswer = currentQuestion.answers.firstWhere((answer) => answer.answer).text;

    setState(() {
      isCorrect = userAnswer == correctAnswer;
      if (isCorrect!) {
        score++;
      }
      showExplanation = true;
    });
  });
}

  Future<void> nextQuestion() async {
    try {
      final questions = await futureQuestions;
      if (currentQuestionIndex < questions.length - 1) {
        setState(() {
          currentQuestionIndex++;
          isCorrect = null;
          showExplanation = false;
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ScoreScreen(score: score),
          ),
        );
      }
    } catch (e) {
      print('Error fetching next question: $e');
      // Handle error (e.g., show an error message to the user)
    }
  }

 @override
Widget build(BuildContext context) {
  return FutureBuilder<List<Question>>(
    future: futureQuestions,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      } else if (snapshot.hasError) {
        return Scaffold(
          body: Center(child: Text("Error: ${snapshot.error}")),
        );
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Scaffold(
          body: Center(child: Text("No questions available")),
        );
      }

      final questions = snapshot.data!;
      final currentQuestion = questions[currentQuestionIndex];

      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Quiz App',
            style: TextStyle(color: Colors.black, fontSize: 25),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 243, 177, 199),
          elevation: 0.0,
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    currentQuestion.questionText,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Image.network(
                    currentQuestion.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading image: $error');
                      return Icon(Icons.error, size: 100, color: Colors.red);
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                  SizedBox(height: 30),
                  if (isCorrect == null) ...[
                    for (var answer in currentQuestion.answers) 
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0), // Adds vertical space between buttons
                        child: ElevatedButton(
                          onPressed: () => checkAnswer(answer.text),
                          child: Text(answer.text, style: TextStyle(fontSize: 20)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          ),
                        ),
                      ),
                  ] else if (showExplanation) ...[
                    Text(
                      isCorrect! ? 'Correct!' : 'Incorrect!',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: isCorrect! ? Colors.green : Colors.red,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      currentQuestion.explanation,
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: nextQuestion,
                      child: Text(
                        currentQuestionIndex < questions.length - 1
                            ? 'Next Question'
                            : 'Finish Quiz',
                        style: TextStyle(fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
}