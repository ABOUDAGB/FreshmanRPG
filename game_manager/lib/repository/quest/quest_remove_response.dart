import 'package:equatable/equatable.dart';

import '../../type_definitions.dart';

class QuestRemoveResponse extends Equatable {
  final bool success;

  const QuestRemoveResponse({required this.success});

  const QuestRemoveResponse.allFields({ required this.success });

  factory QuestRemoveResponse.fromJson({
    required JSON json,
  }) {
    return QuestRemoveResponse.allFields(
        success: json['success']
    );
  }

  @override
  List<Object> get props => [ success ];

  @override
  String toString() {
    return 'QuestRemoveResponse()';
  }

}
