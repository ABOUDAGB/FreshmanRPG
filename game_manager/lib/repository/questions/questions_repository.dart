import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:game_manager/repository/shared/utilities.dart';

import 'get_all_questions_request.dart';
import 'get_all_questions_response.dart';

/**
 * A class for connecting with the backend using the restful server.
 * Deals with anything and everything related to a player.
 */
class QuestionsRepository {
  QuestionsRepository({required this.dio}) {
    dio.options.headers['content-Type'] = 'application/json; charset=UTF-8';
    dio.options.headers['Access-Control-Allow-Origin'] = '*';
    dio.options.baseUrl = Utilities.findBaseURL();
  }
  final Dio dio;

  Future<GetAllQuestionsResponse> getAllQuestions(
      GetAllQuestionsRequest request) async {
    try {
      final response = await dio.get(
        '/question',
        data: jsonEncode(request),
      );
      return GetAllQuestionsResponse.fromJson(json: jsonDecode(response.data));
    } on DioError catch (e) {
      return const GetAllQuestionsResponse(false, questions: []);
    }
  }
}