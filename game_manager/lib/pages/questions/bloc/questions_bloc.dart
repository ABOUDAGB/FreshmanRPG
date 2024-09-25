import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_manager/repository/questions/get_all_questions_request.dart';
import 'package:game_manager/repository/questions/get_all_questions_response.dart';
import 'package:meta/meta.dart';

import 'package:game_manager/repository/questions/questions_repository.dart';

part 'questions_event.dart';
part 'questions_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  // //todo: create npc question repository and dto
  final QuestionsRepository questionRepository;

  QuestionBloc({
    required this.questionRepository,
  }) : super(QuestionInitial()) {
    on<GetQuestionForPageEvent>((event, emit) async {
      emit(QuestionLoading());

      //todo: create quiz bot response
      GetAllQuestionsResponse questionResponse = await questionRepository.getAllQuestions(const GetAllQuestionsRequest());

      emit (QuestionPageReady(questionResponse));
    });
    on<SendQuestionEvent>((event, emit) async {
      emit(QuestionLoading());

      GetAllQuestionsResponse questionResponse = await questionRepository.getAllQuestions(const GetAllQuestionsRequest());

      // todo add basic response / do something between Complete and PageReady
      emit(QuestionComplete(questionResponse));

      emit (QuestionPageReady(questionResponse));
    });
  }
}
