part of 'questions_bloc.dart';

/// The states that the QuestionBloc can be in.

@immutable
abstract class QuestionState extends Equatable {
  @override
  List<Object> get props => [];
}

class QuestionInitial extends QuestionState {}

class QuestionLoading extends QuestionState {}

class QuestionComplete extends QuestionState {
  final GetAllQuestionsResponse response;

  QuestionComplete(this.response);

  @override
  List<Object> get props => [response];
}

class QuestionPageReady extends QuestionState {
  //todo: edit this
  final GetAllQuestionsResponse response;

  QuestionPageReady(this.response);

  @override
  List<Object> get props => [response];
}

