import 'dart:convert';
import 'package:companion_app/repository/player_repository/change_password_request.dart';
import 'package:companion_app/repository/player_repository/player_info_request.dart';
import 'package:companion_app/repository/player_repository/player_info_response.dart';
import 'package:dio/dio.dart';

import '../shared_repository_state.dart';
import 'basic_response.dart';

class PlayerRepository {
  PlayerRepository({required this.dio}) {
    dio.options.headers['content-Type'] = 'application/json; charset=UTF-8';
    dio.options.headers['Access-Control-Allow-Origin'] = '*';
    // dio.options.baseUrl = SharedRepositoryState().findBaseURL();
  }

  final Dio dio;

  Future<PlayerInfoResponse> getPlayerInfo(PlayerInfoRequest request) async {
    try {
      final response = await dio.post(
        '/getPlayerInfo',
        data:jsonEncode(request)
      );
      return PlayerInfoResponse.fromJson(json.decode(response.data));
    } on DioError catch (e) {
      // Handle DioError appropriately
      print('DioError: $e');
      return const PlayerInfoResponse(
        success: false,
        experiencePoints: 0,
        doubloons: 0,
        quests: [],
      );
    }
  }

  Future<BasicResponse> changePassword(ChangePasswordRequest request) async {
    try {
      final response = await dio.post(
        '/player/change-password/',
        data: jsonEncode(request),
      );

      return BasicResponse.fromJson(json: jsonDecode(response.data));
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 400) {
          return BasicResponse.fromJson(json: jsonDecode(e.response!.data));
        }
      }
    }

    return const BasicResponse(
        success: false,
        description: "Password could not be changed. No response from server.");
  }
}
