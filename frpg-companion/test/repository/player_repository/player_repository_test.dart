import 'dart:convert';

import 'package:companion_app/repository/player_repository/basic_response.dart';
import 'package:companion_app/repository/player_repository/change_password_request.dart';
import 'package:companion_app/repository/player_repository/player_info_response.dart';
import 'package:companion_app/repository/player_repository/player_info.dart';
import 'package:companion_app/repository/player_repository/player_info_request.dart';
import 'package:companion_app/repository/player_repository/player_repository.dart';
import 'package:companion_app/repository/quests_objectives_repository/objective.dart';
import 'package:companion_app/repository/quests_objectives_repository/quest.dart';
import 'package:companion_app/repository/shared_repository_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'dart:io';

void main() {

  group('player info tests: ', () {
    late Dio dio;
    late DioAdapter dioAdapter;

    Map<String, dynamic> goodResponse =
    {
      "success": true,
      "description": "Success",
    };

    const Objective firstObjective = Objective(
        questID: 2,
        objectiveID: 3,
        description: "first one",
        objectiveState: "TRIGGERED");
    const secondObjective =
    Objective(
        questID: 3,
        objectiveID: 42,
        description: "second one",
        objectiveState: "COMPLETED");

    const List<Objective> objList = [firstObjective, secondObjective];

    var quest = const Quest(questID: 1, questTitle: 'hey', objectives: objList,
        state: 'TRIGGERED', questDescription: 'description', experiencePointsGained: 5,
        objectivesToFulfillment: 5);

    Map<String, dynamic> goodPlayerInfoResponse = {
      "success": true,
      "experiencePoints": 1,
      "doubloons": 1,
      "clientPlayerQuestList": [quest]
    };

    setUpAll(() {
      dio = Dio();
      dioAdapter = DioAdapter(dio: dio);
      dio.httpClientAdapter = dioAdapter;
      SharedRepositoryState().setDio(dio);
    });

    //
    // test('Good weekly scores request', () async {
    //   const getWeeklyPlayerScoresRequest = GetWeeklyPlayerScoresRequest(playerID: 1);
    //   dioAdapter.onPost('/weeklyPlayerScores',
    //           (request) => request.reply(200, jsonEncode(goodWeeklyScoresResponse)),
    //       data: jsonEncode(getWeeklyPlayerScoresRequest));
    //
    //   ScoreRepository repo = ScoreRepository(dio: dio);
    //
    //   GetWeeklyPlayerScoresResponse response =
    //   await repo.getWeeklyScores(getWeeklyPlayerScoresRequest);
    //   expect(response.success, true);
    //   expect(response.weeklyPlayerScores.length, 2);
    //   expect(response.weeklyPlayerScores.contains(player1), true);
    //   expect(response.weeklyPlayerScores.contains(player2), true);
    //
    //   expect(response.weeklyPlayerScoresWithinCrew.length, 1);
    //   expect(response.weeklyPlayerScoresWithinCrew.contains(player1), true);
    //   expect(response.weeklyPlayerScoresWithinCrew.contains(player2), false);
    // });


    test('Good player info request', () async {
      const getPlayerInfoRequest = PlayerInfoRequest(playerID: 15);
      dioAdapter.onPost('/getPlayerInfo',
              (request) => request.reply(200, jsonEncode(goodPlayerInfoResponse)),
          data: jsonEncode(getPlayerInfoRequest));

      PlayerRepository repo = PlayerRepository(dio:dio);

      PlayerInfoResponse response =
      await repo.getPlayerInfo(getPlayerInfoRequest);
      expect(response.success, true);
      expect(response.experiencePoints, 1);
      expect(response.doubloons, 1);
      expect(response.quests, [quest]);
    });

    test('Good Change Password Request', () async {
      const changePlayerRequest = ChangePasswordRequest(playerName: "username",
          password: "password");
      dioAdapter.onPost('/player/change-password/',
              (request) => request
              .reply(200,
              jsonEncode(goodResponse)),
          data: jsonEncode(changePlayerRequest));

      PlayerRepository repo = PlayerRepository(dio: dio);

      BasicResponse passwordResponse = await repo.changePassword(changePlayerRequest);
      expect(passwordResponse.success, true);
      expect(passwordResponse.description, "Success");
    });
});
}
