part of 'high_score_bloc.dart';

@immutable
abstract class HighScoreEvent {}


class RequestHighScoresEvent extends HighScoreEvent {

  final int playerID;

  RequestHighScoresEvent(this.playerID);

  @override
  String toString() {
    return 'RequestHighScoreEvent(playerID: $playerID';
  }
}

