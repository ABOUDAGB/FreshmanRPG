import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_manager/repository/questions/get_all_questions_request.dart';
import 'package:game_manager/repository/questions/get_all_questions_response.dart';
import 'package:game_manager/repository/questions/questions_repository.dart';
import 'package:game_manager/repository/questions/question.dart';

import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'dart:io';

void main() {
  dotenv.testLoad(fileInput: File('assets/.env').readAsStringSync());

  group('Questions tests: ', () {
    late Dio dio;
    late DioAdapter dioAdapter;

    var question1 = const Question(
      id: 1,
      question: "This is the question",
      answer: "This is the answer",
      startDate: '12-12-2020',
      endDate: '12-12-2023',
    );

    var question2 = const Question(
      id: 2,
      question: "This is the question",
      answer: "This is the answer",
      startDate: '12-12-2020',
      endDate: '12-12-2023',
    );

    Map<String, dynamic> goodQuestionsResponse = {
      "success": true,
      "question": [question1, question2],
    };


    setUp(() {
      dio = Dio();
      dioAdapter = DioAdapter(dio: dio);
      dio.httpClientAdapter = dioAdapter;
    });

    test('Good Questions Request', () async {
      const getAllQuestionsRequest = GetAllQuestionsRequest();
      dioAdapter.onGet('/question', (request) => request
          .reply(200,
          jsonEncode(goodQuestionsResponse)),
          data: jsonEncode(getAllQuestionsRequest));

      QuestionsRepository repo = new QuestionsRepository(dio: dio);

      GetAllQuestionsResponse response = await repo.getAllQuestions(getAllQuestionsRequest);
      expect(response.success, true);
      expect(response.questions.length, 2);
      expect(response.questions.contains(question1), true);
      expect(response.questions.contains(question2), true);
    });

  });
}
