import 'package:kgaona/api/service/question_service.dart';
import 'package:kgaona/domain/question.dart';

class QuestionRepository {
  final QuestionService _questionService = QuestionService();

  Future<List<Question>> getQuestions() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _questionService.getInitialQuestions();
  }
}