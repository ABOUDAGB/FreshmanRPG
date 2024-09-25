import 'package:equatable/equatable.dart';
import '../../type_definitions.dart';

///
/// Object to response for completing login.
///
class LoginWithCredentialsResponse extends Equatable {
  final int playerID;
  final String authKey;
  final bool success;

  ///
  /// Constructor.
  ///
  const LoginWithCredentialsResponse({
    required this.playerID,
    required this.success,
    required this.authKey,
  });

  ///
  /// Factory mapping `JSON` to `LoginWithCredentialsResponse`.
  ///
  factory LoginWithCredentialsResponse.fromJson({
    required JSON json,
  }) {
    return LoginWithCredentialsResponse(
      playerID: json['playerID'],
      success: json['success'],
      authKey: json['authKey']
    );
  }

  ///
  /// Get properties of object for comparison.
  ///
  @override
  List<Object?> get props => [
        playerID,
      ];

  ///
  /// Convert object to string.
  ///
  @override
  String toString() {
    return 'LoginWithCredentialsResponse(playerID: $playerID)';
  }
}
