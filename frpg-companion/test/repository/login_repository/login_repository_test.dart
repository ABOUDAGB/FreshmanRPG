
import 'dart:convert';

import 'package:companion_app/repository/login_repository/confirm_code_request.dart';
import 'package:companion_app/repository/login_repository/confirm_code_response.dart';
import 'package:companion_app/repository/login_repository/generate_reset_password__code_request.dart';
import 'package:companion_app/repository/login_repository/generate_reset_password_code_response.dart';
import 'package:companion_app/repository/login_repository'
    '/login_with_credentials_request.dart';
import 'package:companion_app/repository/shared_repository_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:companion_app/repository/login_repository'
    '/login_with_credentials_response.dart';
import 'package:companion_app/repository/login_repository/login_repository'
    '.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  group('Player Repository Tests: ', () {
    late Dio dio;
    late DioAdapter dioAdapter;
    Map<String, dynamic> goodResponse =
    {
      "playerID": 3,
      "success": true,
      "authKey": "abcdefg",
    };
    Map<String, dynamic> badResponse =
    {
      "playerID": 0,
      "success": false,
      "authKey": "",
    };

    setUpAll(() {
      dio = Dio();
      dioAdapter = DioAdapter(dio: dio);
      dio.httpClientAdapter = dioAdapter;
      SharedRepositoryState().setDio(dio);
    });

    test('Bad Login Request', () async {

      const loginRequest = LoginWithCredentialsRequest(playerName: "merlin",
          password: "px");
      dioAdapter.onPost('/login', (request) => request
          .reply(200,
          jsonEncode(badResponse)),
          data: jsonEncode(loginRequest));

      LoginRepository repo = LoginRepository();

      LoginWithCredentialsResponse response = await repo.loginPlayer(loginRequest);
      expect(response.success, isFalse);
    });

    test('Good Login Request', () async {

      const loginRequest = LoginWithCredentialsRequest(playerName: "merlin",
          password: "pw");
      dioAdapter.onPost('/login', (request) => request
          .reply(200,
          jsonEncode(goodResponse)),
          data: jsonEncode(loginRequest));

      LoginRepository repo = LoginRepository();

      LoginWithCredentialsResponse response = await repo.loginPlayer(loginRequest);
      expect(response.playerID, isNonZero) ;
    });

    test('Request for generating a reset password code', () async {

      const generateCodeRequest = GenerateResetPasswordCodeRequest(userName: "merlin");
      dioAdapter.onPost('/login/generate-reset-code', (request) => request
          .reply(200,
          jsonEncode(goodResponse)),
          data: jsonEncode(generateCodeRequest));

      LoginRepository repo = LoginRepository();

      GenerateResetPasswordCodeResponse response = await repo.generateCode(generateCodeRequest);
      expect(response.success, isTrue) ;
    });

    test('Request for verifying a reset password code', () async {

      const confirmCodeRequest = ConfirmCodeRequest(code: 1234);
      dioAdapter.onPost('/login/compare-codes', (request) => request
          .reply(200,
          jsonEncode(goodResponse)),
          data: jsonEncode(confirmCodeRequest));

      LoginRepository repo = LoginRepository();

      ConfirmCodeResponse response = await repo.confirmCode(confirmCodeRequest);
      expect(response.success, isTrue) ;
    });

  });
}