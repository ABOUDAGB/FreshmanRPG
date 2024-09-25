import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:game_manager/repository/player/all_players_request.dart';
import 'package:game_manager/repository/shared/utilities.dart';

import 'package:game_manager/repository/player/all_players_response.dart';
import 'package:game_manager/repository/player/change_player_request.dart';
import 'package:game_manager/repository/player/create_player_request.dart';
import 'package:game_manager/repository/player/basic_response.dart';
import 'get_all_crews_request.dart';
import 'get_all_crews_response.dart';
import 'package:game_manager/repository/player/get_all_majors_request.dart';
import 'package:game_manager/repository/player/get_all_majors_response.dart';

/**
 * A class for connecting with the backend using the restful server.
 * Deals with anything and everything related to a player.
 */
class CrewRepository {
  CrewRepository({required this.dio}) {
    dio.options.headers['content-Type'] = 'application/json; charset=UTF-8';
    dio.options.headers['Access-Control-Allow-Origin'] = '*';
    dio.options.baseUrl = Utilities.findBaseURL();
  }

  final Dio dio;

  Future<GetAllCrewsResponse> getAllCrews(GetAllCrewsRequest request) async
  {
    try {
      final response = await dio.get(
        '/crews',
        data: jsonEncode(request),
      );
      return GetAllCrewsResponse.fromJson(json: jsonDecode(response.data));
    } on DioError catch (e) {
      return const GetAllCrewsResponse(false, crews: []);
    }
  }

}
