import 'package:equatable/equatable.dart';
import '../../type_definitions.dart';

class Question extends Equatable {
  final int id;
  final String question;
  final String answer;
  final String startDate;
  final String endDate;

  const Question(
      {required this.id,
        required this.question, required this.answer, required this.startDate, required this.endDate});

  @override
  List<Object?> get props => [id, question, answer, startDate, endDate];

  ///
  /// Convert object to JSON.
  ///
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer' : answer,
      'startDate': startDate,
      'endDate' : endDate
    };
  }

  factory Question.fromJson({
    required JSON json,
  }) {
    return Question(
        id: json['id'],
      question: json['question'],
      answer: json['answer'],
      startDate: json['startDate'],
      endDate: json['endDate']
    );
  }
}

