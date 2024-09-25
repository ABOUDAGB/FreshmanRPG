import 'package:equatable/equatable.dart';
import '../../type_definitions.dart';

class PlayerCrewResponse extends Equatable {
  final bool success;
  final int crew;

  const PlayerCrewResponse(this.success, {required this.crew});

  const PlayerCrewResponse.allFields({required this.success, required this.crew});

  factory PlayerCrewResponse.fromJson({
    required JSON json,
  }) {
    return PlayerCrewResponse.allFields(
        success: json['success'],
        crew: json['crew']
    );
  }

  @override
  List<Object?> get props => [success, crew];

  @override
  String toString() {
    return 'PlayerCrewResponse(Players: $crew)';
  }
}