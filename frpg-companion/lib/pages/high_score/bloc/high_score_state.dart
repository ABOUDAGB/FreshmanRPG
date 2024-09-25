part of 'high_score_bloc.dart';

@immutable
abstract class HighScoreState extends Equatable {
  @override
  List<Object> get props => [];

  // get response => null;
}

class HighScorePageInitial extends HighScoreState {}

class HighScoreWaitingForResponse extends HighScoreState {}

class HighScorePageReady extends HighScoreState {
  final GetWeeklyPlayerScoresResponse weeklyPlayerScoresResponse;
  final GetPlayerScoreResponse playerScoreResponse;

  HighScorePageReady(this.weeklyPlayerScoresResponse, this.playerScoreResponse);

  @override
  List<Object> get props => [weeklyPlayerScoresResponse, playerScoreResponse];
}

// part of 'login_bloc.dart';
//
// @immutable
// abstract class LoginState extends Equatable {
//   @override
//   List<Object> get props => [];
// }
//
//
// class LoginInitial extends LoginState {}
//
// class LoginLoading extends LoginState {}
//
// class LoginFailed extends LoginState {
//   final LoginWithCredentialsResponse response;
//
//   LoginFailed(this.response);
//
//   @override
//   List<Object> get props => [response];
// }
//
// class LoginComplete extends LoginState {
//   final LoginWithCredentialsResponse response;
//
//   LoginComplete(this.response);
//
//   @override
//   List<Object> get props => [response];
// }