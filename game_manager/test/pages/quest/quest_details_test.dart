import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_manager/pages/quest/bloc/quest_details_bloc.dart';
import 'package:game_manager/pages/quest/bloc/quest_landing_bloc.dart';
import 'package:game_manager/repository/player/basic_response.dart';
import 'package:game_manager/repository/quest/quest_editing_response.dart';
import 'package:game_manager/repository/quest/quest_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'quest_test.mocks.dart';

class QuestRepositoryTest extends Mock implements QuestRepository {}

@GenerateMocks([QuestRepositoryTest])
Future<void> main() async {
  late MockQuestRepositoryTest questRepo;

  setUpAll(() {
    questRepo = MockQuestRepositoryTest();
  });

  group('Quest Details and Landing Tests: ', () {
    const BasicResponse good = BasicResponse(success: true, description: "Worked");
    const QuestEditingDataResponse goodEditing = QuestEditingDataResponse(true, quests: [], mapNames: [], completionActionTypes: [], objCompletionTypes: []);

    blocTest<QuestDetailsBloc, QuestDetailsState>(
      "Check update and insert flow",
      build: () {
        when(questRepo.upsertQuest(any)).thenAnswer((_) async => good);
        when(questRepo.getQuestEditingData(any)).thenAnswer((_) async => goodEditing);
        return QuestDetailsBloc(questRepository: questRepo);
      },
      act: (bloc) => bloc.add(SendUpsertQuestEvent(1, "", "", const [], 0, "", 1, 2, 3, 4, "", "", true)),
      wait: const Duration(milliseconds: 500),
      expect: () => [QuestDetailsWaitingForResponse(), QuestDetailsComplete(good),QuestDetailsPageReady(goodEditing)],
    );

    const QuestEditingDataResponse goodEditingResponse = QuestEditingDataResponse(true, quests: [], mapNames: [], completionActionTypes: [], objCompletionTypes: []);

    blocTest<QuestDetailsBloc, QuestDetailsState>(
      "Check get flow (quest details bloc)",
      build: () {
        when(questRepo.getQuestEditingData(any)).thenAnswer((_) async => goodEditingResponse);
        return QuestDetailsBloc(questRepository: questRepo);
      },
      act: (bloc) => bloc.add(SendGetQuestDetailsEditingInformationEvent()),
      wait: const Duration(milliseconds: 500),
      expect: () => [QuestDetailsWaitingForResponse(), QuestDetailsPageReady(goodEditingResponse)],
    );

    blocTest<QuestLandingBloc, QuestLandingState>(
      "Check get flow (quest landing bloc)",
      build: () {
        when(questRepo.getQuestEditingData(any)).thenAnswer((_) async => goodEditingResponse);
        return QuestLandingBloc(questRepository: questRepo);
      },
      act: (bloc) => bloc.add(SendGetQuestLandingEditingInformationEvent()),
      wait: const Duration(milliseconds: 500),
      expect: () => [QuestLandingWaitingForResponse(), QuestLandingPageReady(goodEditingResponse)],
    );
  });
}
