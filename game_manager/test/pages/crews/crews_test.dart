import 'package:flutter_test/flutter_test.dart';
import 'package:game_manager/pages/crews/bloc/crews_bloc.dart';
import 'package:game_manager/repository/crew/crew_repository.dart';
import 'package:game_manager/repository/player/basic_response.dart';
import 'package:game_manager/repository/crew/get_all_crews_response.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import 'crews_test.mocks.dart';

class CrewRepositoryTest extends Mock implements CrewRepository {}

@GenerateMocks([CrewRepositoryTest])
Future<void> main() async {
  late MockCrewRepositoryTest crewRepo;

  setUpAll(() {
    crewRepo = MockCrewRepositoryTest();
  });

  // todo refactor this test, add more crew tests
  group('Get Crew Tests: ', () {
    const BasicResponse goodResponse =
        BasicResponse(success: true, description: "got all crews"); // todo ?

    const GetAllCrewsResponse goodCrewsResponse = GetAllCrewsResponse(true, crews: []);

    blocTest<CrewsBloc, CrewsState>( // todo work on this test
      'emits [CrewsLoading, CrewsPageReady] when GetCrewsForPageEvent is added',
      build: () {
        when(crewRepo.getAllCrews(any))
            .thenAnswer((_) async => goodCrewsResponse);
        return CrewsBloc(crewRepository: crewRepo);
      },
      act: (bloc) => bloc.add(GetCrewsForPageEvent()),
      wait: const Duration(milliseconds: 2000),
      expect: () => [CrewsLoading(), CrewsPageReady(goodCrewsResponse)],
    );

    blocTest<CrewsBloc, CrewsState>(
        'emits [CrewsLoading, CrewsComplete] when SendCrewsEvent is added',
        build: () {
          when(crewRepo.getAllCrews(any))
              .thenAnswer((_) async => goodCrewsResponse);
          return CrewsBloc(crewRepository: crewRepo);
      },
      act: (bloc) => bloc.add(SendCrewsEvent("testCrew")),
      wait: const Duration(milliseconds: 2000),
      expect: () => [CrewsLoading(), CrewsPageReady(goodCrewsResponse)],

    );

  });
}
