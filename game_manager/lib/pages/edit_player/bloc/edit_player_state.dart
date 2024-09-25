part of 'edit_player_bloc.dart';

/// The states that the ChangePasswordBloc can be in.

@immutable
abstract class EditPlayerState extends Equatable {
  @override
  List<Object> get props => [];
}

class EditPlayerInitial extends EditPlayerState {}

class EditPlayerLoading extends EditPlayerState {}

class EditPlayerPageReady extends EditPlayerState {
  final AllPlayersResponse playerResponse;
  final GetAllCrewsResponse crewResponse;

  EditPlayerPageReady(this.playerResponse, this.crewResponse);

  @override
  List<Object> get props => [playerResponse, crewResponse];
}

class EditPlayerComplete extends EditPlayerState {
  final BasicResponse response;

  EditPlayerComplete(this.response);

  @override
  List<Object> get props => [response];
}
