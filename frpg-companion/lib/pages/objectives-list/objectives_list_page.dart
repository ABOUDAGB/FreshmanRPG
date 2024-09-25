import 'package:companion_app/model/location_utilities.dart';
import 'package:companion_app/navigation_bar.dart';
import 'package:companion_app/pages/login/login_page.dart';
import 'package:companion_app/pages/objectives-list/bloc/objectives_list_bloc.dart';
import 'package:companion_app/repository/login_repository/login_repository.dart';
import 'package:companion_app/repository/login_repository/logout_request.dart';
import 'package:companion_app/repository/player_repository/player_repository.dart';
import 'package:companion_app/repository/shared/general_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/barcode_scanner.dart';
import '../../repository/player_repository/player_info_response.dart';
import '../../repository/quests_objectives_repository/quests_objectives_repository.dart';
import '../../repository/shared_repository_state.dart';
import 'objective_card.dart';

class ObjectivesListView extends StatefulWidget {
  const ObjectivesListView({required this.playerId, required this.authKey, required this.navContext, Key? key})
      : super(key: key);
  final int playerId;
  final String authKey;
  final BuildContext navContext;

  @override
  State<StatefulWidget> createState() => _ObjectivesListViewState(playerId, authKey, navContext);
}

class _ObjectivesListViewState extends State<ObjectivesListView> {
  _ObjectivesListViewState(
      this.playerID,
      this.authKey,
      this.navContext,
      ) : super();

  final int playerID;
  final String authKey;
  final BuildContext navContext;
  static BaseOptions options = BaseOptions(
      baseUrl: SharedRepositoryState().findBaseURL()
  );
  Dio dio = Dio(options);

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => _infoDialogBuilder(context),
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromRGBO(0, 22, 65, 1.0),
          shape: const CircleBorder(),
          child: const Icon(Icons.question_mark_rounded),
        ),

        resizeToAvoidBottomInset: false,

        body: MultiRepositoryProvider(
            // create: (context) => {PlayerRepository(dio: dio),
            //          QuestsObjectivesRepository()},
            providers: [RepositoryProvider(create: (context) => PlayerRepository(dio: dio)),
              RepositoryProvider(create: (context) => QuestsObjectivesRepository())],
              // PlayerRepository(dio: dio),
              // QuestsObjectivesRepository()],
            child: BlocProvider<ObjectivesListBloc>(
                create: (context) => ObjectivesListBloc(
                    playerRepository: context.read<PlayerRepository>(),
                    questsObjectivesRepository: context.read<QuestsObjectivesRepository>(),
                    playerID: playerID,
                    scanner: BarcodeScanner(),
                    geoLocator: GeoLocatorWrapper())..add(RequestObjectivesEvent
                  (playerID)),
                child: BlocConsumer<ObjectivesListBloc, ObjectivesListState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state is ObjectivesListInitial) {
                        return Center(
                          child: Image.asset(
                            "assets/bettershipredspinning.gif",
                            width: 300,
                            height: 300,
                          ),
                        );
                      } else if (state is ObjectivesListLoading) {
                        return Center(
                          child: Image.asset(
                            "assets/bettershipredspinning.gif",
                            width: 300,
                            height: 300,
                          ),
                        );
                      } else if (state is PlayerInfoLoaded) {
                        return buildObjectivesListScreen(state.response);
                      } else if (state is RestfulCompletionRequestInProgress) {
                        return Center(
                          child: Image.asset(
                            "./assets/bettershipredspinning.gif",
                            width: 300,
                            height: 300,
                          ),
                        );
                      } else if (state is RestfulCompletionRequestComplete) {
                        return buildObjectiveCompletionScreen(state.response);
                      } else if (state is LocationCheckFailed) {
                        return Center(
                            child: Text(state.errorMsg)
                        );
                      } else if (state is QRCodeCheckFailed) {
                        return const Center(
                            child: Text('Invalid QR code. '
                                'Are you scanning the right one?')
                        );
                      } else if (state is QRCodeScanInProgress) {
                        return Center(
                          child: Image.asset(
                            "assets/SU.gif",
                            width: 300,
                            height: 300,
                          ),
                        );
                      } else {
                        return const Center(
                          child: Text('Error'),
                        );
                      }
                    }))));

  }

// Find the ScaffoldMessenger in the widget tree
  Widget buildObjectivesListScreen(PlayerInfoResponse response) => Scaffold(
    appBar: AppBar(
      backgroundColor: const Color.fromRGBO(0, 22, 65, 1.0),
      foregroundColor: Colors.white,
      automaticallyImplyLeading: false,
      leading: IconButton(
        tooltip: 'Log out of the app.',
        onPressed: () async {
          // if (!kDebugMode) {
          //   final login = ref.read(LoginProvider.loginController.notifier);
          //   await login.logOut();
          // }
          // Navigator.pop(context);

          LoginRepository().logoutPlayer(
              LogoutRequest(playerID: playerID, authKey: authKey)
          );
          Navigator.of(navContext as BuildContext).pushReplacement(MaterialPageRoute(
              builder: (context) => const LoginPage()));
        },
        icon: const Icon(
          Icons.logout,
        ),
      ),

      title: Row(
          children: [
            const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('Objectives')
            ),

            Flexible(
                child: MultiBlocProvider(
                  providers: [ BlocProvider<ObjectivesListBloc> (
                    create: (context) =>
                    ObjectivesListBloc(
                        playerRepository: context.read<PlayerRepository>(),
                        questsObjectivesRepository: context.read<QuestsObjectivesRepository>(),
                        playerID: playerID,
                        scanner: BarcodeScanner(),
                        geoLocator: GeoLocatorWrapper())..add(RequestObjectivesEvent(playerID)),
                  ),],
                  child: BlocConsumer<ObjectivesListBloc, ObjectivesListState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return BlocBuilder<ObjectivesListBloc, ObjectivesListState>(
                          builder: (context, state) {
                            if (state is PlayerInfoLoaded) {
                              return getPlayerScore(state.response);
                            } else {
                               return const Center();
                            }
                          }
                      );
                    },
                  ),
                )
            )
      ]
      ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(navContext).pushReplacement(MaterialPageRoute(
                  builder: (context) => NavigationBarApp(playerID, authKey)));
            },
            icon: const Icon(Icons.refresh),
          ),

        ]
    ),
    body: Padding(
      padding: const EdgeInsets.all(12),

        child: Scrollbar(
          thumbVisibility: true,
          controller: scrollController,
          child: SingleChildScrollView(
            child: Column(
                children: response.quests.where((quest) =>
                    quest.objectives.where((obj) =>
                        obj.objectiveState == "TRIGGERED").isNotEmpty)
                    .map((quest) =>
                Container(
                  margin: const EdgeInsets.all(5.0),
                  child: ExpansionTile(
                        childrenPadding: const EdgeInsets.only(bottom: 12),
                        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        collapsedBackgroundColor: const Color.fromRGBO(125, 150, 175, 0.5),
                        backgroundColor: const Color.fromRGBO(125, 150, 200, 0.5),
                        title: Text(quest.questTitle),
                        subtitle: Text(quest.questDescription),
                        children: quest.objectives.where((objective) => objective.objectiveState == "TRIGGERED").map((objective) =>
                            ObjectiveCard(
                                info: objective,
                                playerID: playerID)
                        ).toList())
                    )).toList()
            )
          )
        )
    ),
  );
}

Widget getPlayerScore(PlayerInfoResponse playerInfoResponse) => Padding(
  padding: const EdgeInsets.fromLTRB(20,0,0,0),
  child: FittedBox(
    fit: BoxFit.scaleDown,
      child: Text("Total score: ${playerInfoResponse.experiencePoints}")
  )
);


Widget buildObjectiveCompletionScreen(GeneralResponse response) => const Center(
  child: Text("Objective Completed"),
);
void _close(BuildContext context) {
  Navigator.pop(context);
}
Future<void> _infoDialogBuilder(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Guide'),
        content: Wrap(
          children: <Widget>[
            const Text('How to scan an objective:', style: TextStyle(fontWeight: FontWeight.bold)),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(text: 'Each quest dropdown shows objectives associated with that quest. To complete an objective, '
                      'find it\'s corresponding QR code on campus, then click the QR code icon (',
                      style: TextStyle(color: Colors.black)),
                  WidgetSpan(child: Icon(Icons.qr_code, size: 14)),
                  TextSpan(text: ') for that objective and scan it. To receive points, make sure you have Location services turned on. \n',
                      style: TextStyle(color: Colors.black)),
                ]
              )
            ),
            const Text('To see score rankings:', style: TextStyle(fontWeight: FontWeight.bold)),
            RichText(
                text: const TextSpan(
                    children: [
                    TextSpan(text: 'Click the High Scores icon (',
                          style: TextStyle(color: Colors.black)),
                      WidgetSpan(child: Icon(Icons.leaderboard_outlined, size: 14)),
                      TextSpan(text: ') at the bottom of the page.',
                          style: TextStyle(color: Colors.black)),
                    ]
                )
            ),

          ]
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Close'),
            onPressed: () => _close(context),
          ),
        ],
      );
    },
  );
}


