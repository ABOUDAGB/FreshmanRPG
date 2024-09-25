import 'package:companion_app/repository/quests_objectives_repository/quest.dart';
import 'package:equatable/equatable.dart';

import '../../type_definitions.dart';

class PlayerInfoResponse extends Equatable {
  final bool success;
  final int experiencePoints;
  final int doubloons;
  final List<Quest> quests;

  const PlayerInfoResponse({
    required this.success,
    required this.experiencePoints,
    required this.doubloons,
    required this.quests,
  });

  factory PlayerInfoResponse.fromJson(Map<String, dynamic> json) {
    return PlayerInfoResponse(
      success: json['success'] as bool,
      quests: (json['clientPlayerQuestList'] as List<dynamic>).map((e) => Quest.fromJson(e as Map<String, dynamic>)).toList(),
      experiencePoints: json['experiencePoints'] as int,
      doubloons: json['doubloons'] as int,
    );
  }

  @override
  List<Object?> get props => [success, experiencePoints, doubloons, quests];

  @override
  String toString() {
    return 'PlayerInfoResponse(success: $success, experiencePoints: $experiencePoints, doubloons: $doubloons, quests: $quests)';
  }
}
