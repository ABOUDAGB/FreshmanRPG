import 'dart:math';

import 'package:companion_app/repository/quests_objectives_repository/quest.dart';
import 'package:equatable/equatable.dart';
import '../../type_definitions.dart';

/// Player Controller returns a level and friends list when this request happens.
/// We did not need them so we do not use them.
class Player extends Equatable {
  final int experiencePoints;
  final int doubloons;
  final List<Quest> quests;

  const Player(
      {required this.experiencePoints,
        required this.doubloons,
        required this.quests});

  @override
  List<Object?> get props => [experiencePoints, doubloons, quests];

  ///
  /// Convert object to JSON.
  ///
  Map<String, dynamic> toJson() {
    return {
      'experiencePoints': experiencePoints,
      'doubloons': doubloons,
      'quests': quests
    };
  }

  factory Player.fromJson({
    required JSON json,
  }) {
    return Player(
        experiencePoints: json['experiencePoints'],
        doubloons: json['doubloons'],
        quests: json['quests']
    );
  }
}
