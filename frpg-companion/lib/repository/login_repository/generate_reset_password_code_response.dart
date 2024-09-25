import 'package:equatable/equatable.dart';
import '../../type_definitions.dart';

///
/// Object for a response after generating the password reset code.
///
class GenerateResetPasswordCodeResponse extends Equatable {
  final bool success;

  ///
  /// Constructor.
  ///
  const GenerateResetPasswordCodeResponse({
    required this.success,
  });

  ///
  /// Factory mapping `JSON` to `GenerateResetPasswordCodeResponse`.
  ///
  factory GenerateResetPasswordCodeResponse.fromJson({
    required JSON json,
  }) {
    return GenerateResetPasswordCodeResponse(
        success: json['success']
    );
  }

  ///
  /// Get properties of object for comparison.
  ///
  @override
  List<Object?> get props => [];

  ///
  /// Convert object to string.
  ///
  @override
  String toString() {
    return 'GenerateResetPasswordCodeResponse()';
  }
}
