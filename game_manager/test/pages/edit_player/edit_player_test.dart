import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_manager/pages/edit_player/bloc/edit_player_bloc.dart';
import 'package:game_manager/repository/crew/crew.dart';
import 'package:game_manager/repository/crew/get_all_crews_response.dart';
import 'package:game_manager/repository/player/all_players_response.dart';
import 'package:game_manager/repository/player/basic_response.dart';
import 'package:game_manager/repository/player/player.dart';
import 'package:game_manager/repository/player/player_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../crews/crews_test.mocks.dart';
import 'edit_player_test.mocks.dart';

class PlayerRepositoryTest extends Mock implements PlayerRepository {}

@GenerateMocks([PlayerRepositoryTest])
Future<void> main() async{
  late MockPlayerRepositoryTest playerRepo;
  late MockCrewRepositoryTest crewRepo;

  setUpAll(() {
    playerRepo = MockPlayerRepositoryTest();
    crewRepo = MockCrewRepositoryTest();
  });

  group('Change Password Tests: ', () {
    const BasicResponse goodResponse =
    BasicResponse(success: true, description: "changed");
    AllPlayersResponse playerResponse = AllPlayersResponse(
        true,
        players: [
          Player(
              playerName: "test",
              playerID: 1
          )
        ]);

    GetAllCrewsResponse crewsResponse = const GetAllCrewsResponse(
        true,
        crews: [
          Crew(
              name: "crewTest",
              id: 1
          )
        ]);

    blocTest<ChangePasswordBloc, EditPlayerState>(
      'Check flow of states for page building',
      build: () {
        when(playerRepo.getAllPlayers(any))
            .thenAnswer((_) async => playerResponse);
        when(crewRepo.getAllCrews(any))
            .thenAnswer((_) async => crewsResponse);
        return ChangePasswordBloc(playerRepository: playerRepo, crewRepository: crewRepo);
      },
      act: (bloc) => bloc.add(GetPlayerNamesForPageEvent()),
      wait: const Duration(milliseconds: 500),
      expect: () => [EditPlayerLoading(), EditPlayerPageReady(playerResponse, crewsResponse)],
    );

    blocTest<ChangePasswordBloc, EditPlayerState>(
      'Check flow of states for submittion',
      build: () {
        when(playerRepo.changePassword(any))
            .thenAnswer((_) async => goodResponse);
        return ChangePasswordBloc(playerRepository: playerRepo, crewRepository: crewRepo);
      },
      act: (bloc) => bloc.add(SendChangePasswordEvent("fred", "newpw", 1)),
      wait: const Duration(milliseconds: 500),
      expect: () => [EditPlayerLoading(), EditPlayerComplete(goodResponse), EditPlayerPageReady(playerResponse, crewsResponse)],
    );
  });
}