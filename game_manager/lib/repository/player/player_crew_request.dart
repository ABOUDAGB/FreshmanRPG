import 'package:equatable/equatable.dart';

import '../../type_definitions.dart';

class PlayerCrewRequest extends Equatable {
  final String? playerName;

  const PlayerCrewRequest({
    required this.playerName,
  });

  @override
  List<Object?> get props => [playerName];

  Map<String, dynamic> toJson() {
    return {'playerName': playerName};
  }

  @override
  String toString() {
    return 'PlayerCrewRequest(playerName: $playerName)';
  }

  ///
  /// Convert object to JSON.
  ///
  JSON get asJson => {
    'playerName': playerName,
  };
}