import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_manager/repository/player/all_players_response.dart';
import 'package:game_manager/repository/crew/crew.dart';
import 'package:game_manager/repository/crew/get_all_crews_response.dart';
import 'package:meta/meta.dart';

import '../../../repository/player/basic_response.dart';
import '../../../repository/crew/get_all_crews_request.dart';
import 'package:game_manager/repository/crew/crew_repository.dart';

part 'crews_event.dart';
part 'crews_state.dart';

class CrewsBloc extends Bloc<CrewsEvent, CrewsState> {
  final CrewRepository crewRepository;

  CrewsBloc({
    required this.crewRepository,
  }) : super(CrewsInitial()) {
    on<GetCrewsForPageEvent>((event, emit) async {
      emit(CrewsLoading());

      GetAllCrewsResponse crewsResponse = await crewRepository.getAllCrews(const GetAllCrewsRequest());

      emit (CrewsPageReady(crewsResponse));
    });

    // todo what is this event doing?
    on<SendCrewsEvent>((event, emit) async {
      emit(CrewsLoading());

      GetAllCrewsResponse crewsResponse = await crewRepository.getAllCrews(const GetAllCrewsRequest());
      emit (CrewsPageReady(crewsResponse));
    });
  }
}
