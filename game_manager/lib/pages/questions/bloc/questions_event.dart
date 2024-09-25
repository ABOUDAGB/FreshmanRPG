part of 'questions_bloc.dart';

@immutable
abstract class QuestionEvent {}

class GetQuestionForPageEvent extends QuestionEvent {
  GetQuestionForPageEvent();

  @override
  String toString() {
    return 'GetQuestionForPageEvent()';
  }
}

class SendQuestionEvent extends QuestionEvent {
  final String questionStatement;
  final String answer;
  final String startDate;
  final String endDate;

  SendQuestionEvent(this.questionStatement, this.answer, this.startDate, this.endDate);

  @override
  String toString() {
    return 'SendQuestionEvent(questionStatement: $questionStatement, answer: $answer, startDate: $startDate, endDate: $endDate)';
  }
}
