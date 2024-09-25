part of 'quest_details_bloc.dart';

@immutable
abstract class QuestDetailsState extends Equatable {
  @override
  List<Object> get props => [];
}

class QuestDetailsInitial extends QuestDetailsState {}

class QuestDetailsWaitingForResponse extends QuestDetailsState {}

class QuestDetailsComplete extends QuestDetailsState {
  final BasicResponse response;


  QuestDetailsComplete(this.response);


  @override
  List<Object> get props => [response];
}

class QuestDetailsPageReady extends QuestDetailsState {
  final QuestEditingDataResponse response;

  QuestDetailsPageReady(this.response);

  @override
  List<Object> get props => [response];

}

class DeleteObjective extends QuestDetailsState {}
