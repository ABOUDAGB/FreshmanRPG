import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../repository/score_repository/get_player_score_request.dart';
import '../../../repository/score_repository/score_repository.dart';
import '../../../repository/score_repository/get_player_score_response.dart';
import '../../../repository/score_repository/weekly_player_score.dart';
import '../../../repository/score_repository/get_weekly_player_scores_request.dart';
import '../../../repository/score_repository/get_weekly_player_scores_response.dart';

part 'high_score_event.dart';

part 'high_score_state.dart';

class HighScoreBloc extends Bloc<HighScoreEvent, HighScoreState> {
  final ScoreRepository scoreRepository;
  final BuildContext context;
  bool _testing = false;

  set testing(bool value) {
    _testing = value;
  }

  late bool success;
  late List<WeeklyPlayerScore> weeklyPlayerScores;
  late List<WeeklyPlayerScore> weeklyPlayerScoresWithinCrew;
  late int playerScore;

  HighScoreBloc({required this.context, required this.scoreRepository})
      : super(HighScorePageInitial()) {
    on<RequestHighScoresEvent>((event, emit) async {
      emit(HighScoreWaitingForResponse());
      GetWeeklyPlayerScoresResponse weeklyPlayerScoresResponse = await scoreRepository.getWeeklyScores(
        GetWeeklyPlayerScoresRequest(
          playerID: event.playerID
        )
      );
      GetPlayerScoreResponse playerScoreResponse = await scoreRepository.getPlayerScore(
          GetPlayerScoreRequest(
              playerID: event.playerID
          )
      );
      success = weeklyPlayerScoresResponse.success;
      weeklyPlayerScores = weeklyPlayerScoresResponse.weeklyPlayerScores;
      weeklyPlayerScoresWithinCrew = weeklyPlayerScoresResponse.weeklyPlayerScoresWithinCrew;
      playerScore = playerScoreResponse.playerScore;
      emit(HighScorePageReady(weeklyPlayerScoresResponse, playerScoreResponse));
    });
  }

  // @override
  // void onTransition(Transition<HighScoreEvent, HighScoreState> transition) {
  //   super.onTransition(transition);
  //   if (transition.nextState is HighScorePageReady) {
  //     try {
  //       Navigator.of(context).pushReplacement(MaterialPageRoute(
  //           builder: (context) => ObjectivesListView(playerID, authKey)));
  //     } on FlutterError {
  //       if (!_testing) {
  //         rethrow;
  //       }
  //     }
  //   }
  // }
}


