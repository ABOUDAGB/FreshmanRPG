import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_manager/repository/player/all_players_response.dart';
import 'package:game_manager/repository/player/player_repository.dart';
import 'package:meta/meta.dart';

import '../../../repository/crew/crew_repository.dart';
import '../../../repository/crew/get_all_crews_request.dart';
import '../../../repository/crew/get_all_crews_response.dart';
import '../../../repository/player/all_players_request.dart';
import '../../../repository/player/basic_response.dart';
import '../../../repository/player/change_player_request.dart';

part 'edit_player_event.dart';
part 'edit_player_state.dart';

class ChangePasswordBloc extends Bloc<EditPlayerEvent, EditPlayerState> {
  late ChangePlayerRequest data;
  final PlayerRepository playerRepository;
  final CrewRepository crewRepository;

  ChangePasswordBloc({
    required this.playerRepository,
    required this.crewRepository
  }) : super(EditPlayerInitial()) {
    on<GetPlayerNamesForPageEvent>((event, emit) async {
      emit(EditPlayerLoading());

      AllPlayersResponse playerResponse = await playerRepository.getAllPlayers(const AllPlayersRequest());
      GetAllCrewsResponse crewsResponse = await crewRepository.getAllCrews(const GetAllCrewsRequest());

      emit (EditPlayerPageReady(playerResponse, crewsResponse));
    });

    on<SendChangePasswordEvent>((event, emit) async {
      emit(EditPlayerLoading());

      BasicResponse response = await playerRepository.changePassword(ChangePlayerRequest
        (playerName: event.playerName, password: event.newPassword, crewID: event.newCrewID));

      emit(EditPlayerComplete(response));

      AllPlayersResponse playerResponse = await playerRepository.getAllPlayers(const AllPlayersRequest());
      GetAllCrewsResponse crewResponse = await crewRepository.getAllCrews(const GetAllCrewsRequest());

      emit (EditPlayerPageReady(playerResponse, crewResponse));
    });
  }
}
