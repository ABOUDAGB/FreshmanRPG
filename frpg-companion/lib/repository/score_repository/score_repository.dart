import 'dart:convert';
import 'package:companion_app/repository/score_repository/get_weekly_player_scores_request.dart';
import 'package:companion_app/repository/score_repository/get_weekly_player_scores_response.dart';
import 'package:dio/dio.dart';
import 'package:companion_app/repository/shared_repository_state.dart';

import 'get_player_score_request.dart';
import 'get_player_score_response.dart';

/**
 * A class for connecting with the backend using the restful server.
 * Deals with anything and everything related to a player.
 */
class ScoreRepository {
  ScoreRepository({required this.dio}) {
    dio.options.headers['content-Type'] = 'application/json; charset=UTF-8';
    dio.options.headers['Access-Control-Allow-Origin'] = '*';
  }

  final Dio dio;

  Future<GetWeeklyPlayerScoresResponse> getWeeklyScores(
      GetWeeklyPlayerScoresRequest request) async {
    try {
      final response = await dio.post(
        '/weeklyPlayerScores',
        data: jsonEncode(request),
      );
      return GetWeeklyPlayerScoresResponse.fromJson(
          json: jsonDecode(response.data));
    } on DioError catch (e) {
      return const GetWeeklyPlayerScoresResponse(false, weeklyPlayerScores: [], weeklyPlayerScoresWithinCrew: []);
    }
  }


  Future<GetPlayerScoreResponse> getPlayerScore(
      GetPlayerScoreRequest request) async {
      String m = jsonEncode(request);
    try {
      final response = await dio.get(
        '/getPlayerScoreThisWeek',
        data: jsonEncode(request),
      );
      return GetPlayerScoreResponse.fromJson(json : jsonDecode(response.data));
    } on DioError catch (e) {
      return const GetPlayerScoreResponse(false, playerScore: -1);
    }
  }
}
