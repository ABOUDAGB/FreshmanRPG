import 'package:equatable/equatable.dart';
import '../../type_definitions.dart';

///
/// Object to response for player score.
///
class GetPlayerScoreResponse extends Equatable {
  final bool success;
  final int playerScore;

  ///
  /// Constructor.
  ///
  const GetPlayerScoreResponse( this.success,
      {required this.playerScore});

  // constructor for all fields
  const GetPlayerScoreResponse.allFields(
      {required this.success, required this.playerScore});

  ///
  /// Factory mapping `JSON` to `GetPlayerScoreResponse`.
  ///
  factory GetPlayerScoreResponse.fromJson({
    required JSON json,
  }) {
    return GetPlayerScoreResponse.allFields(
        success: json['success'],
        playerScore: (json['playerScore']));
  }
  ///
  /// Get properties of object for comparison.
  ///
  @override
  List<Object?> get props => [success, playerScore];

  ///
  /// Convert object to string.
  ///
  @override
  String toString() {
    return 'GetPlayerScoreResponse(playerScore: $playerScore)' ;
  }
}
