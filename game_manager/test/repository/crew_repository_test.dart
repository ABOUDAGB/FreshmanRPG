import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_manager/repository/crew/crew_repository.dart';
import 'package:game_manager/repository/crew/crew.dart';
import 'package:game_manager/repository/crew/get_all_crews_request.dart';
import 'package:game_manager/repository/crew/get_all_crews_response.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'dart:io';

void main() {
  dotenv.testLoad(fileInput: File('assets/.env').readAsStringSync());

  group('Crews Tests: ', () {
    late Dio dio;
    late DioAdapter dioAdapter;


    var firstCrew = const Crew(
        id: 1,
        name: "Off by One"
    );
    var secondCrew = const Crew(
        id: 2,
        name: "Out of Bounds"
    );
    Map<String, dynamic> goodCrewsResponse = {
      "success": true,
      "crews": [firstCrew, secondCrew],
    };


    setUp(() {
      dio = Dio();
      dioAdapter = DioAdapter(dio: dio);
      dio.httpClientAdapter = dioAdapter;
    });

    test('Good Crews Request', () async {
      const getAllCrewsRequest = GetAllCrewsRequest();
      dioAdapter.onGet('/crews', (request) => request
          .reply(200,
          jsonEncode(goodCrewsResponse)),
          data: jsonEncode(getAllCrewsRequest));

      CrewRepository repo = CrewRepository(dio: dio);

      GetAllCrewsResponse response = await repo.getAllCrews(getAllCrewsRequest);
      expect(response.success, true);
      expect(response.crews.length, 2);
      expect(response.crews.contains(firstCrew), true);
      expect(response.crews.contains(secondCrew), true);
    });
  });
}
