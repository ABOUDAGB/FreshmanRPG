import 'dart:convert';

import 'package:companion_app/repository/player_repository/player_info_request.dart';
import 'package:companion_app/repository/player_repository/player_repository.dart';
import 'package:companion_app/repository/quests_objectives_repository/complete-objective-request.dart';
import 'package:companion_app/repository/player_repository/player_info_response.dart';
import 'package:companion_app/repository/quests_objectives_repository/objective.dart';
import 'package:companion_app/repository/quests_objectives_repository/quest.dart';
import 'package:companion_app/repository/quests_objectives_repository/quests_objectives_repository.dart';
import 'package:companion_app/repository/shared/general_response.dart';
import 'package:companion_app/repository/shared_repository_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  group('Quests and Objectives Repository Tests: ', () {
    late Dio dio;
    late DioAdapter dioAdapter;

    var firstObjective = const Objective(
        questID: 2,
        objectiveID: 3,
        description: "first one",
        objectiveState: "TRIGGERED");
    var secondObjective =
        const Objective(questID: 3, objectiveID: 42, description: "second one", objectiveState: 'TRIGGERED');

    var objectives =[firstObjective, secondObjective];
    
    var quest = Quest(questID: 1, objectives: objectives, state: "triggered", questTitle: "hey", questDescription: "description", experiencePointsGained: 3, objectivesToFulfillment: 3);

    var quests = [quest];

    Map<String, dynamic> goodResponse = {
      "success": true,
      "clientPlayerQuestList": quests,
      "experiencePoints": 3,
      "doubloons": 3
    };

    setUpAll(() {
      dio = Dio();
      dioAdapter = DioAdapter(dio: dio);
      dio.httpClientAdapter = dioAdapter;
      SharedRepositoryState().setDio(dio);
    });

    test('Request for objective list', () async {
      const request = PlayerInfoRequest(playerID: 42);
      dioAdapter.onPost('/getPlayerInfo',
          (request) => request.reply(200, jsonEncode(goodResponse)),
          data: jsonEncode(request));

      PlayerRepository repo = PlayerRepository(dio: dio);

      PlayerInfoResponse response = await repo.getPlayerInfo(request);

      expect(response.quests.elementAt(0).objectives.length, 2);
      expect(response.quests.elementAt(0).objectives.contains(firstObjective), true);
      expect(response.quests.elementAt(0).objectives.contains(secondObjective), true);
      expect(response.doubloons, 3);
    });

    test('http status not 200 on getting all objectives', () async {
      const playerInfoRequest = PlayerInfoRequest(playerID: 44);

      final dioError = DioException(
        error: {'message': 'We planned for  getting all objectives to fail!'},
        requestOptions: RequestOptions(path: '/playerInfo'),
      );

      dioAdapter.onGet('/playerInfo', (server) => server.throws(401, dioError),
          data: jsonEncode(playerInfoRequest));

      PlayerRepository repo = PlayerRepository(dio: dio);

      PlayerInfoResponse response =
          await repo.getPlayerInfo(playerInfoRequest);
      expect(response.success, false);
    });

    test('Good request to complete and objective', () async {
      const request =
          CompleteObjectiveRequest(playerID: 42, questID: 4, objectiveID: 42);
      dioAdapter.onPost(
          '/complete-objective',
          (request) => request.reply(
              200,
              jsonEncode(const GeneralResponse(
                  success: true, description: 'good job!'))),
          data: jsonEncode(request));

      QuestsObjectivesRepository repo = QuestsObjectivesRepository();
      GeneralResponse response = await repo.completeObjective(request);
      expect(response.success, true);
    });

    test('http status 401 on completing an objective', () async {
      const request =
          CompleteObjectiveRequest(playerID: 42, questID: 42, objectiveID: 42);

      final dioError = DioException(
        error: {'message': 'We planned for completing an objective to fail!'},
        response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: '/complete-objective')),
        requestOptions:
            RequestOptions(path: '/complete-objective', method: 'POST'),
        type: DioExceptionType.badResponse,
      );

      dioAdapter.onPost(
          '/complete-objective', (server) => server.throws(401, dioError),
          data: jsonEncode(request));

      QuestsObjectivesRepository repo = QuestsObjectivesRepository();

      GeneralResponse response = await repo.completeObjective(request);
      expect(response.success, false);
      expect(response.description, 'Http error 401');
    });

  });
}
