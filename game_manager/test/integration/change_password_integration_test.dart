import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_manager/pages/edit_player/edit_player_page.dart';
import 'package:game_manager/pages/shared/widgets/password.dart';
import 'package:game_manager/repository/crew/crew.dart';
import 'package:game_manager/repository/crew/get_all_crews_response.dart';
import 'package:game_manager/repository/player/all_players_response.dart';
import 'package:game_manager/repository/player/player.dart';
import 'package:game_manager/repository/player/player_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../pages/crews/crews_test.mocks.dart';
import '../pages/edit_player/edit_player_test.mocks.dart';

class PlayerRepositoryTest extends Mock implements PlayerRepository {}

@GenerateMocks([PlayerRepositoryTest])
Future<void> main() async{
  late MockPlayerRepositoryTest mockPlayerRepo;
  late MockCrewRepositoryTest mockCrewRepo;

  setUpAll(() {
    mockPlayerRepo = MockPlayerRepositoryTest();
    mockCrewRepo = MockCrewRepositoryTest();
  });

  testWidgets('Change Password Flow', (WidgetTester tester) async {
    // Create our mock response
    AllPlayersResponse mockAllPlayersResponse = AllPlayersResponse(
        true,
        players: [
          Player(
              playerName: "test",
              playerID: 1,
          )
        ]);

    GetAllCrewsResponse mockAllCrewsResponse = const GetAllCrewsResponse(
        true,
        crews: [
          Crew(
              name: "crewTest",
              id: 0
          )
        ]);

    // When we call getAllPlayers, return our mock response
    when(mockPlayerRepo.getAllPlayers(any))
        .thenAnswer((_) async => mockAllPlayersResponse);

    when(mockCrewRepo.getAllCrews(any))
        .thenAnswer((_) async =>mockAllCrewsResponse);

    var page = EditPlayerPage(playerRepository: mockPlayerRepo, crewRepository: mockCrewRepo);
    // Generate the widget tree with our mock repository
    await tester.pumpWidget(
          MaterialApp(
            home: page,
          ),
    );

    await tester.pumpAndSettle();

    // Ensure the page is built
    expect(find.byType(EditPlayerPage), findsOneWidget);

    // Ensure the submit button is visible
    expect(find.byType(ElevatedButton).first, findsOneWidget);

    // Ensure the elevated button onPressed is null since the password fields are empty and no player is selected
    expect((tester.firstWidget(find.byType(ElevatedButton)) as ElevatedButton).onPressed, isNull);
    await tester.pumpAndSettle();

    // Find the DropdownButtonFormField Widget, and fill it with test data
    var dropDown = find.byType(DropdownMenu<String>);
    expect(dropDown, findsOneWidget);

    // open the dropdown
    await tester.tap(dropDown);
    await tester.pumpAndSettle();

    print(dropDown.first.toString());

    // click on Merlin
    final dropdownItem = find.text('test').last; // todo see if "test" is actually a player in the test data
    await tester.tap(dropdownItem);
    await tester.pumpAndSettle();

    // Ensure the password field is visible
    expect(find.byType(PasswordField), findsOneWidget);

    await tester.enterText(find.byType(PasswordField).first, "GoodPassword123!");
    await tester.pumpAndSettle();

    // Ensure the confirm password field is visible
    // There are multiple since PasswordField is a wrapper for TextField
    expect(find.byType(TextField), findsWidgets);

    // We need the confirm password field, so we use the third TextField
    await tester.enterText(find.byType(TextField).at(2), "GoodPassword123!");
    await tester.pumpAndSettle();

    // Check to see if the onPressed function is null in the ElevatedButton
    expect(
        (tester.firstWidget(find.byType(ElevatedButton)) as ElevatedButton)
            .onPressed,
        isNotNull);


  });
}
