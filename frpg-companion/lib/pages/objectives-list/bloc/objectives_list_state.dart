part of 'objectives_list_bloc.dart';

class LocationCheckFailed extends ObjectivesListState {
  final String errorMsg;

  LocationCheckFailed(this.errorMsg);
  @override
  List<Object> get props => [errorMsg];
}

class QRCodeCheckFailed extends ObjectivesListState {}

class RestfulCompletionRequestComplete extends ObjectivesListState {
  final GeneralResponse response;

  RestfulCompletionRequestComplete(this.response);

  @override
  List<Object> get props => [response];
}

class RestfulCompletionRequestInProgress extends ObjectivesListState {}

class PlayerInfoLoaded extends ObjectivesListState {
  final PlayerInfoResponse response;

  PlayerInfoLoaded(this.response);

  @override
  List<Object> get props => [response];
}

class ObjectivesListInitial extends ObjectivesListState {}

class ObjectivesListLoading extends ObjectivesListState {}

@immutable
abstract class ObjectivesListState extends Equatable {
  @override
  List<Object> get props => [];
}

class QRCodeScanInProgress extends ObjectivesListState {}


