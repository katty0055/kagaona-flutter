import 'package:flutter/material.dart';
import 'package:kgaona/api/service/question_service.dart';
import 'package:kgaona/components/side_menu.dart';
import 'package:kgaona/domain/question.dart';
import 'package:kgaona/theme/colors.dart';
import 'package:kgaona/views/result_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  final QuestionService _questionService = QuestionService();
  List<Question> questionsList = [];
  int currentQuestionIndex = 0;
  int userScore = 0;
  int? selectedAnswerIndex;
  bool? isCorrectAnswer;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final questions = await _questionService.getQuestions();
    setState(() {
      questionsList = questions;
    });
  }

  void _onAnswerSelected(int selectedIndex) {
    setState(() {
      selectedAnswerIndex = selectedIndex;
      isCorrectAnswer = questionsList[currentQuestionIndex].isCorrect(selectedIndex);

      if (isCorrectAnswer!) {
        userScore++;
      }
    });

    // SnackBar con estilo del tema
    final theme = Theme.of(context);
    final snackBarMessage = isCorrectAnswer == true
        ? SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: theme.colorScheme.onPrimary),
                const SizedBox(width: 8),
                const Text('¡Correcto!'),
              ],
            ),
            backgroundColor: AppColors.success,
          )
        : SnackBar(
            content: Row(
              children: [
                Icon(Icons.cancel, color: theme.colorScheme.onPrimary),
                const SizedBox(width: 8),
                const Text('Incorrecto'),
              ],
            ),
            backgroundColor: AppColors.error,
          );

    ScaffoldMessenger.of(context).showSnackBar(snackBarMessage);

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (currentQuestionIndex < questionsList.length - 1) {
        setState(() {
          currentQuestionIndex++;
          selectedAnswerIndex = null;
          isCorrectAnswer = null;
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              finalScoreGame: userScore, 
              totalQuestions: questionsList.length,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (questionsList.isEmpty) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                'Cargando preguntas...',
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      );
    }

    final questionCounterText = 'Pregunta ${currentQuestionIndex + 1} de ${questionsList.length}';
    final currentQuestion = questionsList[currentQuestionIndex];
  
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Juego de Preguntas',
        ),
      ),
      drawer: const SideMenu(),
      backgroundColor: theme.scaffoldBackgroundColor,      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 0,
              shape: theme.cardTheme.shape,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      '¡A responder las preguntas!',
                      style: theme.textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withAlpha(27),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'Puntaje: $userScore',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary.withAlpha(27),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            questionCounterText,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  currentQuestion.questionText,
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Opciones de respuesta
            Expanded(
              child: ListView.builder(
                itemCount: currentQuestion.answerOptions.length,
                itemBuilder: (context, index) {
                  final option = currentQuestion.answerOptions[index];
                  
                  // Determinar el color del botón según el estado
                  Color buttonColor;
                  Color textColor = theme.colorScheme.onPrimary;
                  
                  if (selectedAnswerIndex != null) {
                    if (isCorrectAnswer! && selectedAnswerIndex == index) {
                      buttonColor = AppColors.success;
                    } else if (!isCorrectAnswer! && selectedAnswerIndex == index) {
                      buttonColor = AppColors.error;
                    } else {
                      buttonColor = theme.disabledColor;
                      textColor = theme.colorScheme.onSurface.withAlpha(153);
                    }
                  } else {
                    buttonColor = theme.colorScheme.primary;
                  }
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: FilledButton(
                      onPressed: selectedAnswerIndex == null 
                        ? () => _onAnswerSelected(index)
                        : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: textColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        disabledBackgroundColor: buttonColor,
                        disabledForegroundColor: textColor,
                      ),
                      child: Text(
                        option,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: textColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () {
                Navigator.pop(context);
              },
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.secondary.withAlpha(51),
                foregroundColor: theme.colorScheme.secondary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Volver al Inicio',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}