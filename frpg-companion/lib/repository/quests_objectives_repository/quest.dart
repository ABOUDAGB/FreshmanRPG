import 'dart:math';

import 'package:equatable/equatable.dart';
import '../../type_definitions.dart';
import 'objective.dart';

class Quest extends Equatable {
  final int questID;
  final List<Objective> objectives;
  final String state;
  final String questTitle;
  final String questDescription;
  final int experiencePointsGained;
  final int objectivesToFulfillment;

  const Quest({
    required this.questID,
    required this.objectives,
    required this.state,
    required this.questTitle,
    required this.questDescription,
    required this.experiencePointsGained,
    required this.objectivesToFulfillment,

  });

  @override
  List<Object?> get props => [questID, objectives, state,
    questTitle, questDescription, experiencePointsGained, objectivesToFulfillment];

  Map<String, dynamic> toJson() {
    return {
      'questID': questID,
      'questTitle': questTitle,
      'questDescription': questDescription,
      'experiencePointsGained': experiencePointsGained,
      'objectivesToFulfillment': objectivesToFulfillment,
      'objectiveList': objectives.map((objective) => objective.toJson()).toList(),
      'questState': state,
    };
  }

  factory Quest.fromJson(Map<String, dynamic> json) {
    return Quest(
      questID: json['questID'],
      questTitle: json['questTitle'],
      questDescription: json['questDescription'],
      experiencePointsGained: json['experiencePointsGained'],
      objectivesToFulfillment: json['objectivesToFulfillment'],
      objectives: (json['objectiveList'] as List<dynamic>).map((e) => Objective.fromJson(json: e)).toList(),
      state: json['questState'],

    );
  }
}
