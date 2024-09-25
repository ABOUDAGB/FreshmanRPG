import 'package:equatable/equatable.dart';
import '../../type_definitions.dart';

class WeeklyPlayerScore extends Equatable {
  final int playerID;
  final int weeklyScore;
  final String playerName;

  const WeeklyPlayerScore(
      {required this.playerID,
      required this.playerName,
      required this.weeklyScore});

  @override
  List<Object?> get props => [playerID, playerName, weeklyScore ];

  ///
  /// Convert object to JSON.
  ///
  Map<String, dynamic> toJson() {
    return {
      'playerID': playerID,
      'playerName': playerName,
      'weeklyScore': weeklyScore,
    };
  }

  factory WeeklyPlayerScore.fromJson({
    required JSON json,
  }) {
    return WeeklyPlayerScore(
      playerID: json['playerID'],
      playerName: json['playerName'],
      weeklyScore: json['weeklyScore'],

    );
  }
}
