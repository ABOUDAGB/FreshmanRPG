
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:game_manager/repository/player/basic_response.dart';
import 'package:game_manager/repository/quest/quest_editing_response.dart';
import 'package:game_manager/repository/quest/quest_remove_request.dart';
import 'package:game_manager/repository/quest/quest_remove_response.dart';
import 'package:meta/meta.dart';

import '../../../repository/quest/quest_editing_request.dart';
import '../../../repository/quest/quest_repository.dart';

part 'quest_landing_event.dart';
part 'quest_landing_state.dart';

class QuestLandingBloc extends Bloc<QuestLandingEvent, QuestLandingState> {
  final QuestRepository questRepository;

  QuestLandingBloc({
    required this.questRepository,
  }) : super(QuestLandingInitial()) {

    on<SendGetQuestLandingEditingInformationEvent>((event, emit) async {
      emit(QuestLandingWaitingForResponse());

      QuestEditingDataResponse response = await questRepository.getQuestEditingData(const QuestEditingDataRequest());

      emit(QuestLandingPageReady(response));
    });

    on<SendQuestRemoveEvent>((event, emit) async {
      emit(QuestLandingWaitingForResponse());

      // remove the quest
      await questRepository.removeQuest(QuestRemoveRequest(id: event.questID));

      // re-fetch all the quests and give them to the page
      QuestEditingDataResponse questList = await questRepository.getQuestEditingData(const QuestEditingDataRequest());
      emit(QuestLandingPageReady(questList));
    });

  }
}
