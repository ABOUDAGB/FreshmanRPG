part of 'quest_details_bloc.dart';


@immutable
abstract class QuestDetailsEvent {}

class SendUpsertQuestEvent extends QuestDetailsEvent {
  final int id;
  final String? title;
  final String? description;
  final List<ObjectiveRecordDTO> objectives;
  final int xpGained;
  final String? triggerMapName;
  final int triggerRow;
  final int triggerCol;
  final int objectivesForFulfillment;
  final int completionActionType;
  final String? startDate;
  final String? endDate;
  final bool easterEgg;

  SendUpsertQuestEvent(
      this.id,
      this.title,
      this.description,
      this.objectives,
      this.xpGained,
      this.triggerMapName,
      this.triggerRow,
      this.triggerCol,
      this.objectivesForFulfillment,
      this.completionActionType,
      this.startDate,
      this.endDate,
      this.easterEgg);

  @override
  String toString() {
    return 'SendUpsertQuestDetailsEvent(id: $id, title: $title, description: $description, objectives: $objectives, xpGained: $xpGained, triggerMapName: $triggerMapName, triggerRow: $triggerRow, triggerCol: $triggerCol, objectivesForFulfillment: $objectivesForFulfillment, completionActionType: $completionActionType, startDate: $startDate, endDate: $endDate, easterEgg: $easterEgg)';
  }
}

class SendGetQuestDetailsEditingInformationEvent extends QuestDetailsEvent {
  SendGetQuestDetailsEditingInformationEvent()
      : super();
  @override
  String toString() {
    return 'GetQuestEditingInformationEvent()';
  }

}
class SendGetQuestInformation extends QuestDetailsEvent{
  final String title;

  SendGetQuestInformation(this.title);

  @override
  String toString() {
    return 'QuestInformationEvent(title: $title)';
  }

}

class DeleteObjectiveEvent extends QuestDetailsEvent {
  final int objectiveId;
  final int questId;

  DeleteObjectiveEvent(this.objectiveId, this.questId);

  @override
  String toString() {
    return 'DeleteObjectiveEvent()';
  }

}
