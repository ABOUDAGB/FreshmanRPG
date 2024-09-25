import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_manager/repository/quest/delete_objective_request.dart';
import 'package:game_manager/repository/quest/quest_editing_response.dart';
import 'package:game_manager/repository/quest/upsert_quest_request.dart';
import 'package:meta/meta.dart';

import '../../../repository/player/basic_response.dart';
import '../../../repository/quest/objective_record.dart';
import '../../../repository/quest/quest_editing_request.dart';
import '../../../repository/quest/quest_repository.dart';

part 'quest_details_event.dart';

part 'quest_details_state.dart';

class QuestDetailsBloc extends Bloc<QuestDetailsEvent, QuestDetailsState> {
  final QuestRepository questRepository;

  QuestDetailsBloc({
    required this.questRepository,
  }) : super(QuestDetailsInitial()) {
    on<SendUpsertQuestEvent>((event, emit) async {
      emit(QuestDetailsWaitingForResponse());

      BasicResponse response = await questRepository.upsertQuest(UpsertQuestRequest(id: event.id, title: event.title, description: event.description, objectives: event.objectives, xpGained: event.xpGained, triggerMapName: event.triggerMapName, triggerRow: event.triggerRow, triggerCol: event.triggerCol, objectivesForFulfillment: event.objectivesForFulfillment, completionActionType: event.completionActionType, startDate: event.startDate, endDate: event.endDate, easterEgg: event.easterEgg));

      emit(QuestDetailsComplete(response));

      /*
        TODO: The below is a temporary solution to solving the "infinite loading" problem on quest editing page.
               Find a better solution
               Description of problem: the page is not set up to build the input screen after a QuestComplete state.
                                       It only rebuilds the input screen with a QuestPageReady state
       */
      QuestEditingDataResponse quest_response = await questRepository.getQuestEditingData(const QuestEditingDataRequest());

      emit(QuestDetailsPageReady(quest_response));
    });

    on<SendGetQuestDetailsEditingInformationEvent>((event, emit) async {
      emit(QuestDetailsWaitingForResponse());

      QuestEditingDataResponse response = await questRepository.getQuestEditingData(const QuestEditingDataRequest());

      emit(QuestDetailsPageReady(response));
    });

    on<DeleteObjectiveEvent>((event, emit) async {
      emit(DeleteObjective());

      BasicResponse response = await questRepository.deleteObjective(DeleteObjectiveRequest(event.objectiveId, event.questId));

      emit(QuestDetailsComplete(response));

      /*
        TODO: The below is a temporary solution to solving the "infinite loading" problem on quest editing page.
               Find a better solution
               Description of problem: the page is not set up to build the input screen after a QuestComplete state.
                                       It only rebuilds the input screen with a QuestPageReady state
       */
      QuestEditingDataResponse quest_response = await questRepository.getQuestEditingData(const QuestEditingDataRequest());

      emit(QuestDetailsPageReady(quest_response));
    });
  }
}
