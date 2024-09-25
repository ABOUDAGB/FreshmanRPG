import 'package:equatable/equatable.dart';


///
/// Object to request for a generated code for a password reset using username.
///
class GenerateResetPasswordCodeRequest extends Equatable {
  final String userName;

  ///
  /// Constructor
  ///
  const GenerateResetPasswordCodeRequest(
      {required this.userName});

  ///
  /// Converting object to string
  ///
  @override
  String toString() {
    return 'GenerateResetPasswordCodeRequest(userName: $userName)';
  }

  ///
  /// Get properties for comparison
  ///
  @override
  List<Object?> get props => [userName];

  ///
  /// Convert object to JSON.
  ///
  Map<String, dynamic> toJson() {
    return {'userName': userName};
  }
}
