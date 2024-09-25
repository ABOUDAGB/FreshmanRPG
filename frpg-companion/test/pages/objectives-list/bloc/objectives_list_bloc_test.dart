import 'package:bloc_test/bloc_test.dart';
import 'package:companion_app/repository/player_repository/player_repository.dart';
import 'package:companion_app/repository/quests_objectives_repository/quest.dart';
import 'package:geolocator/geolocator.dart';
import 'package:companion_app/model/barcode_scanner.dart';
import 'package:companion_app/model/location_utilities.dart';
import 'package:companion_app/model/position_with_status.dart';
import 'package:companion_app/pages/objectives-list/bloc/objectives_list_bloc.dart';
import 'package:companion_app/repository/player_repository/player_info_response.dart';
import 'package:companion_app/repository/quests_objectives_repository/objective.dart';
import 'package:companion_app/repository/quests_objectives_repository/quests_objectives_repository.dart';
import 'package:companion_app/repository/shared/general_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'objectives_list_bloc_test.mocks.dart';

class QuestsObjectivesRepositoryMock extends Mock
    implements QuestsObjectivesRepository {}

class PlayerRepositoryMock extends Mock
    implements PlayerRepository {}

class BarCodeScannerMock extends Mock implements BarcodeScanner {}

class GeoLocatorWrapperMock extends Mock implements GeoLocatorWrapper {}

@GenerateMocks(
    [QuestsObjectivesRepositoryMock, PlayerRepositoryMock, BarCodeScannerMock, GeoLocatorWrapperMock])
Future<void> main() async {
  late MockQuestsObjectivesRepositoryMock questRepo;
  late MockPlayerRepositoryMock playerRepo;
  late MockBarCodeScannerMock mockScanner;
  late MockGeoLocatorWrapperMock mockGeoLocator;

  setUpAll(() {
    questRepo = MockQuestsObjectivesRepositoryMock();
    playerRepo = MockPlayerRepositoryMock();
    mockScanner = MockBarCodeScannerMock();
    mockGeoLocator = MockGeoLocatorWrapperMock();
  });

  group('Objective page tests', () {
    const PlayerInfoResponse goodObjectiveListResponse =
        PlayerInfoResponse(success: true, experiencePoints: 4, doubloons: 3,
            quests: [Quest(questID: 1, objectives: [Objective(questID: 3, objectiveID: 4, description: 'stupid objective', objectiveState: 'TRIGGERED'),
            ], state: 'TRIGGERED', questTitle: 'A Fake Quest', questDescription: 'it\'s so fake',
    experiencePointsGained: 5, objectivesToFulfillment: 3)]);

    blocTest<ObjectivesListBloc, ObjectivesListState>(
      'Check flow of states when retrieving all objectives',
      build: () {
        when(playerRepo.getPlayerInfo(any))
            .thenAnswer((_) async => goodObjectiveListResponse);
        return ObjectivesListBloc(
            playerRepository: playerRepo,
            questsObjectivesRepository: questRepo,
            playerID: 42,
            scanner: mockScanner,
            geoLocator: mockGeoLocator);
      },
      act: (bloc) => bloc.add(RequestObjectivesEvent(42)),
      expect: () => [
        ObjectivesListLoading(),
        PlayerInfoLoaded(goodObjectiveListResponse)
      ],
    );

    /************************
     * Successful objective completion without location verification
     */
    const GeneralResponse completeObjectiveResponseNoLoc =
        GeneralResponse(success: true, description: 'Objective Complete');
    blocTest<ObjectivesListBloc, ObjectivesListState>(
      'Check flow of states when completing an objective without location verification',
      build: () {
        when(questRepo.completeObjective(any))
            .thenAnswer((_) async => completeObjectiveResponseNoLoc);
        when(mockScanner.scan()).thenAnswer((_) async => "4_13_42.0_42.0_0");
        when(mockGeoLocator.getCurrentPosition()).thenAnswer((_) async =>
            PositionWithStatus(valid: true, latitude: 4.13, longitude: 42.42));
        when(mockGeoLocator.isLocationEnabled()).thenAnswer((_) async => true);
        when(mockGeoLocator.checkPermission())
            .thenAnswer((_) async => LocationPermission.always);
        when(mockGeoLocator.locationMatches(any, any, any))
            .thenAnswer((_) => false);
        return ObjectivesListBloc(
            playerRepository: playerRepo,
            questsObjectivesRepository: questRepo,
            playerID: 42,
            scanner: mockScanner,
            geoLocator: mockGeoLocator);
      },
      act: (bloc) => bloc.add(RequestQRCodeScanEvent(42, 4, 13)),
      expect: () => [
        QRCodeScanInProgress(),
        RestfulCompletionRequestComplete(completeObjectiveResponseNoLoc)
      ],
    );

    /************************
     * Successful objective completion
     */
    const GeneralResponse completeObjectiveResponse =
        GeneralResponse(success: true, description: 'Objective Complete');
    blocTest<ObjectivesListBloc, ObjectivesListState>(
      'Check flow of states when completing an objective',
      build: () {
        when(questRepo.completeObjective(any))
            .thenAnswer((_) async => completeObjectiveResponse);
        when(mockScanner.scan()).thenAnswer((_) async => "4_13_42.0_42.0_1");
        when(mockGeoLocator.getCurrentPosition()).thenAnswer((_) async =>
            PositionWithStatus(valid: true, latitude: 4.13, longitude: 42.42));
        when(mockGeoLocator.isLocationEnabled()).thenAnswer((_) async => true);
        when(mockGeoLocator.checkPermission())
            .thenAnswer((_) async => LocationPermission.always);
        when(mockGeoLocator.locationMatches(any, any, any))
            .thenAnswer((_) => true);
        return ObjectivesListBloc(
            playerRepository: playerRepo,
            questsObjectivesRepository: questRepo,
            playerID: 42,
            scanner: mockScanner,
            geoLocator: mockGeoLocator);
      },
      act: (bloc) => bloc.add(RequestQRCodeScanEvent(42, 4, 13)),
      expect: () => [
        QRCodeScanInProgress(),
        RestfulCompletionRequestComplete(completeObjectiveResponse)
      ],
    );

    /************************
     * QR code is missing data
     */
    blocTest<ObjectivesListBloc, ObjectivesListState>(
      'Check that we get the QR code failed message when scanning a QR code with missing data',
      build: () {
        when(questRepo.completeObjective(any))
            .thenAnswer((_) async => completeObjectiveResponse);
        when(mockScanner.scan()).thenAnswer((_) async => "3_13_42.0_42.0");
        return ObjectivesListBloc(
            playerRepository: playerRepo,
            questsObjectivesRepository: questRepo,
            playerID: 42, scanner: mockScanner,
            geoLocator: mockGeoLocator);
      },
      act: (bloc) => bloc.add(RequestQRCodeScanEvent(42, 3, 13)),
      expect: () => [
        QRCodeScanInProgress(),
        QRCodeCheckFailed()
      ]
    );

    /************************
     * QR code has bad formatting
     */
    blocTest<ObjectivesListBloc, ObjectivesListState>(
      'Check that we get the QR code failed message when scanning an invalid QR code',
      build: () {
        when(questRepo.completeObjective(any))
            .thenAnswer((_) async => completeObjectiveResponse);
        when(mockScanner.scan()).thenAnswer((_) async => "3_13_42.a_b_c");
        return ObjectivesListBloc(
            playerRepository: playerRepo,
            questsObjectivesRepository: questRepo,
            playerID: 42, scanner: mockScanner,
            geoLocator: mockGeoLocator);
      },
      act: (bloc) => bloc.add(RequestQRCodeScanEvent(42, 3, 13)),
      expect: () => [
        QRCodeScanInProgress(),
        QRCodeCheckFailed()
      ]
    );

    /************************
     * QR code does not match selected objective
     */
    blocTest<ObjectivesListBloc, ObjectivesListState>(
      'Check flow of states when scan for an objective is incorrect',
      build: () {
        when(questRepo.completeObjective(any))
            .thenAnswer((_) async => completeObjectiveResponse);
        when(mockScanner.scan()).thenAnswer((_) async => "3_13_42.0_42.0_1");
        when(mockGeoLocator.isLocationEnabled()).thenAnswer((_) async => true);
        when(mockGeoLocator.checkPermission())
            .thenAnswer((_) async => LocationPermission.always);
        when(mockGeoLocator.getCurrentPosition()).thenAnswer(
            (_) async => PositionWithStatus(latitude: 42, longitude: 42));
        when(mockGeoLocator.locationMatches(any, any, any))
            .thenAnswer((_) => true);
        return ObjectivesListBloc(
            playerRepository: playerRepo,
            questsObjectivesRepository: questRepo,
            playerID: 42,
            scanner: mockScanner,
            geoLocator: mockGeoLocator);
      },
      act: (bloc) => bloc.add(RequestQRCodeScanEvent(42, 4, 13)),
      expect: () => [
        QRCodeScanInProgress(),
        QRCodeCheckFailed()
      ],
    );

    /************************
     * Location services disabled
     */
    blocTest<ObjectivesListBloc, ObjectivesListState>(
      'Check flow of states when location services are disabled',
      build: () {
        when(questRepo.completeObjective(any))
            .thenAnswer((_) async => completeObjectiveResponse);
        when(mockScanner.scan()).thenAnswer((_) async => "3_13_42.0_42.0_1");
        when(mockGeoLocator.isLocationEnabled()).thenAnswer((_) async => false);
        return ObjectivesListBloc(
            playerRepository: playerRepo,
            questsObjectivesRepository: questRepo,
            playerID: 42,
            scanner: mockScanner,
            geoLocator: mockGeoLocator);
      },
      act: (bloc) => bloc.add(RequestQRCodeScanEvent(42, 4, 13)),
      expect: () => [
        QRCodeScanInProgress(),
        LocationCheckFailed('Location Permissions Not Granted')
      ],
    );

    /************************
     * Too far from the target
     */
    blocTest<ObjectivesListBloc, ObjectivesListState>(
      'Check flow of states when too far from QR code location',
      build: () {
        when(questRepo.completeObjective(any))
            .thenAnswer((_) async => completeObjectiveResponse);
        when(mockScanner.scan()).thenAnswer((_) async => "3_13_42.0_42.0_1");
        when(mockGeoLocator.isLocationEnabled()).thenAnswer((_) async => true);
        when(mockGeoLocator.checkPermission())
            .thenAnswer((_) async => LocationPermission.always);
        when(mockGeoLocator.locationMatches(any, any, any))
            .thenAnswer((_) => false);
        return ObjectivesListBloc(
            playerRepository: playerRepo,
            questsObjectivesRepository: questRepo,
            playerID: 42,
            scanner: mockScanner,
            geoLocator: mockGeoLocator);
      },
      act: (bloc) => bloc.add(RequestQRCodeScanEvent(42, 4, 13)),
      expect: () => [
        QRCodeScanInProgress(),
        LocationCheckFailed('You are not close enough to the target location')
      ],
    );
  });
}
