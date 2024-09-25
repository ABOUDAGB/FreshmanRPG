
part of 'quest_landing_bloc.dart';

@immutable
abstract class QuestLandingState extends Equatable {
  @override
  List<Object> get props => [];
}

class QuestLandingInitial extends QuestLandingState {}

class QuestLandingWaitingForResponse extends QuestLandingState {}

class QuestLandingPageReady extends QuestLandingState {
  final QuestEditingDataResponse response;

  QuestLandingPageReady(this.response);

  @override
  List<Object> get props => [response];

}
