part of 'quest_landing_bloc.dart';

@immutable
abstract class QuestLandingEvent {}

// todo to get quest names, possibly need refactor
class SendGetQuestLandingEditingInformationEvent extends QuestLandingEvent {
  SendGetQuestLandingEditingInformationEvent()
      : super();
  @override
  String toString() {
    return 'GetQuestEditingInformationEvent()';
  }

}

class SendQuestRemoveEvent extends QuestLandingEvent {
  final int questID;

  SendQuestRemoveEvent(this.questID) : super();

  @override
  String toString() {
    return 'SendQuestRemoveEvent()';
  }
}
