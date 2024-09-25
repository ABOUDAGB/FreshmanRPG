import 'package:companion_app/repository/score_repository/weekly_player_score.dart';
import 'package:equatable/equatable.dart';

import '../../type_definitions.dart';

class GetWeeklyPlayerScoresResponse extends Equatable {
  final bool success;
  final List<WeeklyPlayerScore> weeklyPlayerScores;
  final List<WeeklyPlayerScore> weeklyPlayerScoresWithinCrew;

  const GetWeeklyPlayerScoresResponse(this.success,
      {required this.weeklyPlayerScores, required this.weeklyPlayerScoresWithinCrew});

  const GetWeeklyPlayerScoresResponse.allFields(
      {required this.success, required this.weeklyPlayerScores, required this.weeklyPlayerScoresWithinCrew});

  factory GetWeeklyPlayerScoresResponse.fromJson({
    required JSON json,
  }) {
    return GetWeeklyPlayerScoresResponse.allFields(
        success: json['success'],
        weeklyPlayerScores: (json['weeklyPlayerScores'] as List)
            .map((e) => WeeklyPlayerScore.fromJson(json: e))
            .toList(), weeklyPlayerScoresWithinCrew: (json['weeklyPlayerScoresWithinCrew'] as List)
        .map((e) => WeeklyPlayerScore.fromJson(json: e))
        .toList());
  }

  @override
  List<Object> get props => [success, weeklyPlayerScores, weeklyPlayerScoresWithinCrew];

  @override
  String toString() {
    return 'GetWeeklyPlayerScoresResponse(weeklyPlayerScores: $weeklyPlayerScores, weeklyPlayerScoresWithinCrew: $weeklyPlayerScoresWithinCrew)';
  }
}
