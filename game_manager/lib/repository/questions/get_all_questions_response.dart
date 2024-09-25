import 'package:equatable/equatable.dart';
import 'package:game_manager/repository/questions/question.dart';

import '../../type_definitions.dart';

class GetAllQuestionsResponse extends Equatable {
  final bool success;
  final List<Question> questions;

  const GetAllQuestionsResponse(this.success, {required this.questions});

  const GetAllQuestionsResponse.allFields({required this.success, required this.questions});

  factory GetAllQuestionsResponse.fromJson({
    required JSON json,
  }) {
    return GetAllQuestionsResponse.allFields(
        success: json['success'],
        questions: (json['question'] as List)
            .map((e) => Question.fromJson(json: e))
            .toList()
    );
  }

  @override
  List<Object> get props => [success, questions];

  @override
  String toString() {
    return 'GetAllQuestionsResponse(question: $questions)';
  }
}