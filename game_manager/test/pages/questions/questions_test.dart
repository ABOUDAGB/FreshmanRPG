import 'package:flutter_test/flutter_test.dart';
import 'package:game_manager/pages/questions/bloc/questions_bloc.dart';
import 'package:game_manager/repository/questions/get_all_questions_response.dart';
import 'package:game_manager/repository/questions/questions_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import 'questions_test.mocks.dart';

class QuestionsRepositoryTest extends Mock implements QuestionsRepository {}

@GenerateMocks([QuestionsRepositoryTest])
Future<void> main() async {
  late MockQuestionsRepositoryTest questionRepo;

  setUpAll(() {
    questionRepo = MockQuestionsRepositoryTest();
  });

  group('Get Question Tests: ', () {
    // use basic response?
    // const BasicResponse goodResponse = BasicResponse(success: true, description: "got all Questions");

    const GetAllQuestionsResponse goodQuestionResponse = GetAllQuestionsResponse(true, questions: []);

    blocTest<QuestionBloc, QuestionState>(
      'emits [QuestionLoading, QuestionPageReady] when GetQuestionsForPageEvent is added',
      build: () {
        when(questionRepo.getAllQuestions(any))
            .thenAnswer((_) async => goodQuestionResponse);
        return QuestionBloc(questionRepository: questionRepo);
      },
      act: (bloc) => bloc.add(GetQuestionForPageEvent()),
      wait: const Duration(milliseconds: 2000),
      expect: () => [QuestionLoading(), QuestionPageReady(goodQuestionResponse)],
    );

    blocTest<QuestionBloc, QuestionState>(
        'emits [CrewsLoading, CrewsComplete] when SendCrewsEvent is added',
        build: () {
          when(questionRepo.getAllQuestions(any))
              .thenAnswer((_) async => goodQuestionResponse);
          return QuestionBloc(questionRepository: questionRepo);
      },
      act: (bloc) => bloc.add(SendQuestionEvent("test question", "test answer", "1/1/2024", "1/1/2024")),
      wait: const Duration(milliseconds: 2000),
      expect: () => [QuestionLoading(), QuestionComplete(goodQuestionResponse), QuestionPageReady(goodQuestionResponse)],
    );
  });
}
