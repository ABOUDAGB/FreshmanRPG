part of 'edit_player_bloc.dart';

@immutable
abstract class EditPlayerEvent {}

class GetPlayerNamesForPageEvent extends EditPlayerEvent {
  GetPlayerNamesForPageEvent();

  @override
  String toString() {
    return 'GetPlayerNamesForPageEvent()';
  }
}

class SendChangePasswordEvent extends EditPlayerEvent {
  final String playerName;
  final String newPassword;
  final int newCrewID;

  SendChangePasswordEvent(this.playerName, this.newPassword, this.newCrewID);

  @override
  String toString() {
    return 'SendChangePasswordEvent(playerName: $playerName, password: $newPassword, crewID: $newCrewID)';
  }
}
