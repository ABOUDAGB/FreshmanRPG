import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:game_manager/repository/quest/delete_objective_request.dart';
import 'package:game_manager/repository/quest/quest_editing_request.dart';
import 'package:game_manager/repository/quest/quest_editing_response.dart';
import 'package:game_manager/repository/quest/quest_remove_request.dart';
import 'package:game_manager/repository/quest/quest_remove_response.dart';

import 'package:game_manager/repository/quest/upsert_quest_request.dart';

import '../player/basic_response.dart';

import '../shared/utilities.dart';

class QuestRepository {
  QuestRepository({required this.dio}) {
    dio.options.headers['content-Type'] = 'application/json; charset=UTF-8';
    dio.options.headers['Access-Control-Allow-Origin'] = '*';
    dio.options.baseUrl = Utilities.findBaseURL();
  }

  final Dio dio;

  //UpsertQuestRequest
  //BasicResponse
  Future<BasicResponse> upsertQuest(UpsertQuestRequest request) async {
    try {
      final response = await dio.post(
        '/quest/upsert',
        data: jsonEncode(request),
      );

      return BasicResponse.fromJson(json: jsonDecode(response.data));
    } on DioError catch (e) {
      final errorResponse = BasicResponse.fromJson(
        json: jsonDecode(e.response?.data ?? '{}'),
      );
      String desc = errorResponse.description;
      return BasicResponse(success: false, description: desc);
    }

}

  Future<QuestEditingDataResponse> getQuestEditingData(QuestEditingDataRequest request) async {
    try {
      final response = await dio.get(
        '/quest/getQuestEditingInfo',
        data: jsonEncode(request),
      );
      return QuestEditingDataResponse.fromJson(json: jsonDecode(response.data));
    } on DioError {
      return const QuestEditingDataResponse(false, quests: [], mapNames: [], completionActionTypes: [], objCompletionTypes: []);
    }
  }

  Future<BasicResponse> deleteObjective(DeleteObjectiveRequest request) async {
    try {
      /* TODO: Currently, this doesn't work. Whenever this request gets sent,
           DioError will have the following erorr from the server:
           DioError [bad response]: The request returned an invalid status code of 406.*/
      final response = await dio.delete( // todo <- maybe use dio.post
        '/objectives/delete',
        data: jsonEncode(request),
      );
      return BasicResponse.fromJson(json: jsonDecode(response.data));
    } on DioError catch (e) {
      print("$e");
      return const BasicResponse(success: false, description: "Unable to delete objective");
    }
  }

  // todo write a test for this?
  Future<QuestRemoveResponse> removeQuest(QuestRemoveRequest request) async {
    try {
      final response = await dio.post(
        '/quest/remove',
        data: jsonEncode(request),
      );
      return QuestRemoveResponse.fromJson(json: jsonDecode(response.data));
    } on DioException catch (e) {
      if (kDebugMode) {
        print("$e");
      }
      return const QuestRemoveResponse(success: false);
    }
  }
}
