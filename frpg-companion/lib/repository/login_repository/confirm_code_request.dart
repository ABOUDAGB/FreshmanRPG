import 'package:equatable/equatable.dart';


///
/// Object to request for a code confirmation.
///
class ConfirmCodeRequest extends Equatable {
  final int code;

  ///
  /// Constructor
  ///
  const ConfirmCodeRequest(
      {required this.code});

  ///
  /// Converting object to string
  ///
  @override
  String toString() {
    return 'ConfirmCodeRequest(code: $code)';
  }

  ///
  /// Get properties for comparison
  ///
  @override
  List<Object?> get props => [code];

  ///
  /// Convert object to JSON.
  ///
  Map<String, dynamic> toJson() {
    return {'userName': code};
  }
}
