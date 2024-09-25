part of 'crews_bloc.dart';

/// The states that the ChangePasswordBloc can be in.

@immutable
abstract class CrewsState extends Equatable {
  @override
  List<Object> get props => [];
}

class CrewsInitial extends CrewsState {}

class CrewsLoading extends CrewsState {}

class CrewsComplete extends CrewsState {
  final BasicResponse response;

  CrewsComplete(this.response);

  @override
  List<Object> get props => [response];
}

class CrewsPageReady extends CrewsState {
  final GetAllCrewsResponse response;

  CrewsPageReady(this.response);

  @override
  List<Object> get props => [response];
}

