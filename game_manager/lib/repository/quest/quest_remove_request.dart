import 'package:equatable/equatable.dart';

import '../../type_definitions.dart';

class QuestRemoveRequest extends Equatable {
  final int id;

  const QuestRemoveRequest({ required this.id });

  @override
  List<Object?> get props => [ id ];

  Map<String, dynamic> toJson() {
    return { 'id': id };
  }

  @override
  String toString() {
    return 'QuestRemoveRequest(questID: $id)';
  }

  JSON get asJson => { 'questID': id };

}
