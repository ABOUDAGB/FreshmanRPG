import 'package:equatable/equatable.dart';

class GetWeeklyPlayerScoresRequest extends Equatable {
  final int playerID;
  const GetWeeklyPlayerScoresRequest({required this.playerID});

  @override
  List<Object?> get props => [playerID];

  Map<String, dynamic> toJson() {
    return {'playerID': playerID};
  }

  @override
  String toString() {
    return 'GetWeeklyPlayerScoresRequest(playerID: $playerID)';
  }
}
