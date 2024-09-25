import 'dart:convert';

import 'package:companion_app/repository/score_repository/get_player_score_response.dart';
import 'package:companion_app/repository/score_repository/get_weekly_player_scores_request.dart';
import 'package:companion_app/repository/score_repository/get_player_score_request.dart';
import 'package:companion_app/repository/score_repository/get_weekly_player_scores_response.dart';
import 'package:companion_app/repository/score_repository/score_repository.dart';
import 'package:companion_app/repository/score_repository/weekly_player_score.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'dart:io';

void main() {

  group('weekly player scores tests: ', () {
    late Dio dio;
    late DioAdapter dioAdapter;

    var player1 =
        const WeeklyPlayerScore(playerID: 1, playerName: "bob", weeklyScore: 5);

    var player2 = const WeeklyPlayerScore(
        playerID: 2, playerName: "janice", weeklyScore: 6);

    Map<String, dynamic> goodWeeklyScoresResponse = {
      "success": true,
      "weeklyPlayerScores": [player1, player2],
      "weeklyPlayerScoresWithinCrew": [player1]
    };

    Map<String, dynamic> goodScoreResponse = {
      "success": true,
      "playerScore": player2.weeklyScore,
    };

    setUp(() {
      dio = Dio();
      dioAdapter = DioAdapter(dio: dio);
      dio.httpClientAdapter = dioAdapter;
    });

    test('Good weekly scores request', () async {
      const getWeeklyPlayerScoresRequest = GetWeeklyPlayerScoresRequest(playerID: 1);
      dioAdapter.onPost('/weeklyPlayerScores',
          (request) => request.reply(200, jsonEncode(goodWeeklyScoresResponse)),
          data: jsonEncode(getWeeklyPlayerScoresRequest));

      ScoreRepository repo = ScoreRepository(dio: dio);

      GetWeeklyPlayerScoresResponse response =
          await repo.getWeeklyScores(getWeeklyPlayerScoresRequest);
      expect(response.success, true);
      expect(response.weeklyPlayerScores.length, 2);
      expect(response.weeklyPlayerScores.contains(player1), true);
      expect(response.weeklyPlayerScores.contains(player2), true);

      expect(response.weeklyPlayerScoresWithinCrew.length, 1);
      expect(response.weeklyPlayerScoresWithinCrew.contains(player1), true);
      expect(response.weeklyPlayerScoresWithinCrew.contains(player2), false);
    });


    test('Good player score request', () async {
      const getPlayerScoreRequest = GetPlayerScoreRequest(playerID: 2);
      dioAdapter.onGet('/getPlayerScoreThisWeek',
              (request) => request.reply(200, jsonEncode(goodScoreResponse)),
          data: jsonEncode(getPlayerScoreRequest));

      //QuestsObjectivesRepository repo = QuestsObjectivesRepository();
      ScoreRepository repo = ScoreRepository(dio: dio);

      GetPlayerScoreResponse response =
      await repo.getPlayerScore(getPlayerScoreRequest);
      expect(response.success, true);
      expect(response.playerScore, 6);
    });
  });
}
