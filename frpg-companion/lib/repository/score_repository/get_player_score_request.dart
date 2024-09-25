import 'package:equatable/equatable.dart';

class GetPlayerScoreRequest extends Equatable {
  final int playerID;

  const GetPlayerScoreRequest({required this.playerID});

  @override
  List<Object?> get props => [playerID];

  Map<String, dynamic> toJson() {
    return {'playerID': playerID};
  }

  @override
  String toString() {
    return 'GetPlayerScoreRequest(playerID: $playerID)';
  }
}