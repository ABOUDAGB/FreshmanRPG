import 'dart:convert';
import 'package:companion_app/repository/quests_objectives_repository/complete-objective-request.dart';
import 'package:dio/dio.dart';

import '../shared/general_response.dart';
import '../shared_repository_state.dart';

class QuestsObjectivesRepository {
  QuestsObjectivesRepository() {
    _dio = SharedRepositoryState().getDio()!;
  }

  late final Dio _dio;

  // todo delete or uncomment
  // Future<PlayerInfoResponse> getAllObjectives(
  //     AllObjectivesRequest request) async {
  //   try {
  //     final response = await _dio.get(
  //       '/objectives',
  //       data: jsonEncode(request),
  //     );
  //     return PlayerInfoResponse.fromJson(json: jsonDecode(response.data));
  //   } on DioError {
  //     return const PlayerInfoResponse(false, objectives: []);
  //   }
  // }

  Future<GeneralResponse> completeObjective(
      CompleteObjectiveRequest request) async {

    try {
      final response = await _dio.post(
        '/complete-objective',
        data: jsonEncode(request),
      );
      return GeneralResponse.fromJson(json: jsonDecode(response.data));
    } on DioError catch (e) {
      return GeneralResponse(
          success: false,
          description: 'Http error '
              '${e.response?.statusCode}');
    }
  }

}
