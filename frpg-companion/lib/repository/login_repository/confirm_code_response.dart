import 'package:equatable/equatable.dart';
import '../../type_definitions.dart';

///
/// Object for a response after verifying code for password reset.
///
class ConfirmCodeResponse extends Equatable {
  final bool success;

  ///
  /// Constructor.
  ///
  const ConfirmCodeResponse({
    required this.success,
  });

  ///
  /// Factory mapping `JSON` to `ConfirmCodeResponse`.
  ///
  factory ConfirmCodeResponse.fromJson({
    required JSON json,
  }) {
    return ConfirmCodeResponse(
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
    return 'ConfirmCodeResponse()';
  }
}
