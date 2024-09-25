import 'package:equatable/equatable.dart';

class PlayerInfoRequest extends Equatable {
  final int playerID;
  const PlayerInfoRequest({required this.playerID});

  @override
  List<Object?> get props => [playerID];

  Map<String, dynamic> toJson() {
    return {'playerID': playerID};
  }

  @override
  String toString() {
    return 'getPlayerInfo(playerID: $playerID)';
  }
}
