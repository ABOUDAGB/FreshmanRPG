part of 'crews_bloc.dart';

@immutable
abstract class CrewsEvent {}

class GetCrewsForPageEvent extends CrewsEvent {
  GetCrewsForPageEvent();

  @override
  String toString() {
    return 'GetCrewsForPageEvent()';
  }
}

class SendCrewsEvent extends CrewsEvent {
  final String crewName;

  SendCrewsEvent(this.crewName);

  @override
  String toString() {
    return 'SendCrewsEvent(playerName: $crewName)';
  }
}

/**
 * class SendGetMajorsAndCrewsEvent extends CreatePlayerPageEvent {

    SendGetMajorsAndCrewsEvent();
    /*
    returns the major and crews event string
    */
    @override
    String toString() {
    return 'SendGetMajorsAndCrewsEvent()';
    }
    }
 */