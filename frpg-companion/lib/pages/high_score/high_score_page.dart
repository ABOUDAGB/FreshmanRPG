import 'package:companion_app/repository/score_repository/get_weekly_player_scores_response.dart';
import 'package:companion_app/repository/score_repository/get_player_score_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/score_repository/score_repository.dart';
import '../../repository/shared_repository_state.dart';
import 'bloc/high_score_bloc.dart';

class HighScorePage extends StatefulWidget {
  final ScoreRepository scoreRepository;
  const HighScorePage(this.playerID, {Key? key, required this.scoreRepository}) : super(key: key);
  final int playerID;

  @override
  State<HighScorePage> createState() => _HighScorePageState(playerID);
}

class _HighScorePageState extends State<HighScorePage> {
  _HighScorePageState(
      this.playerID,
      ) : super();
  static BaseOptions options = BaseOptions(
      baseUrl: SharedRepositoryState().findBaseURL()
  );
  Dio dio = Dio(options);


  late ScoreRepository scoreRepository;
  final formKey = GlobalKey<FormState>();
  final playerName = TextEditingController();

  // store crews/names todo
  // store player id todo
  final int playerID;

  final scrollController = ScrollController();



  // store player score todo
  // store player weekly store (if separate) todo
  // store crew high score todo

  @override
  void initState() {
    super.initState();
    scoreRepository = widget.scoreRepository;
  }

  @override
  dispose() {
    super.dispose();
    playerName.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(0, 21, 65, 1.0),
            foregroundColor: Colors.white,
            title: const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text("Weekly High Scores")
            ),
            actions: [
              MultiRepositoryProvider(providers: [
                RepositoryProvider(create: (context) => ScoreRepository(dio: dio)),
              ], child:
              Flexible(
                child: MultiBlocProvider(
                  providers: [ BlocProvider<HighScoreBloc> (
                  create: (context) =>
                  HighScoreBloc(
                    context: context,
                    scoreRepository: context.read<ScoreRepository>())
                  ..add(RequestHighScoresEvent(playerID)),
              ),],
                  child: BlocConsumer<HighScoreBloc, HighScoreState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return BlocBuilder<HighScoreBloc, HighScoreState>(
                          builder: (context, state) {
                            if (state is HighScorePageReady) {
                              return getPlayerScore(state.playerScoreResponse);
                            } else {
                              return Center();
                            }
                          });
                    },
                  ),
              )
              ))


            ],
            bottom: const TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white,
              tabs: [
                Tab(text: "Overall",),
                Tab(text: "Crew")
              ]
            )
          ),
          body: TabBarView(
            children: [
              MultiRepositoryProvider(
                providers: [
                  RepositoryProvider(create: (context) => ScoreRepository(dio: dio)),
                ],
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider<HighScoreBloc>(
                      create: (context) =>
                      HighScoreBloc(
                          context: context,
                          scoreRepository: context.read<ScoreRepository>())
                        ..add(RequestHighScoresEvent(
                            playerID)), /*todo event to get scores stuff*/
                    )],
                  child:
                  BlocConsumer<HighScoreBloc, HighScoreState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return BlocBuilder<HighScoreBloc, HighScoreState>(
                          builder: (context, state) {
                            if (state is HighScorePageReady) {
                              return buildScoreList(state.weeklyPlayerScoresResponse);
                            } else {
                              return Center(
                                  child: Image.asset(
                                    "assets/bettershipredspinning.gif",
                                    width: 300,
                                    height: 300,
                                  ),
                              );
                            }
                          });
                    },
                  ),
                ),
              ),
              MultiRepositoryProvider(
                providers: [
                  RepositoryProvider(create: (context) => ScoreRepository(dio: dio)),
                ],
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider<HighScoreBloc>(
                      create: (context) =>
                      HighScoreBloc(
                          context: context,
                          scoreRepository: context.read<ScoreRepository>())
                        ..add(RequestHighScoresEvent(
                            playerID)), /*todo event to get scores stuff*/
                    )],
                  child:
                  BlocConsumer<HighScoreBloc, HighScoreState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return BlocBuilder<HighScoreBloc, HighScoreState>(
                          builder: (context, state) {
                            if (state is HighScorePageReady) {
                              return buildScoreListWithinCrew(state.weeklyPlayerScoresResponse);
                            } else {
                              return Center(
                                  child: Image.asset(
                                    "assets/bettershipredspinning.gif",
                                    width: 300,
                                    height: 300,
                                  ),);
                            }
                          });
                    },
                  ),
                ),
              ),
            ]
          )
        ),
      ),
    );
  }
  
  Widget getPlayerScore(GetPlayerScoreResponse playerScoreResponse) => Padding(
    padding: const EdgeInsets.all(12),
    child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text("Weekly score: ${playerScoreResponse.playerScore}")
    ),
  );

  Widget buildScoreList(GetWeeklyPlayerScoresResponse scoreResponse) => Padding(
    padding: const EdgeInsets.all(24.0),
    child: Column(
      children: [
        Expanded(
          child: DataTable(
            columns: const <DataColumn>[
              DataColumn(label: Text('Placement')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Scores')),
            ],
            rows: scoreResponse.weeklyPlayerScores.asMap().entries.map((score) {
              if (score.value.playerID == playerID) {
                return DataRow(
                    // color: MaterialStateColor.resolveWith((states) => const Color.fromRGBO(0, 22, 65, .9)),
                    color: MaterialStateColor.resolveWith((states) => const Color.fromRGBO(239, 55, 62, 1.0)),
                    cells: [
                  DataCell(Text((score.key + 1).toString(),
                    style: const TextStyle(color: Colors.white))),
                  DataCell(Text(score.value.playerName,
                    style: const TextStyle(color: Colors.white))),
                  DataCell(Text(score.value.weeklyScore.toString(),
                      style: const TextStyle(color: Colors.white))),
                    ]);
              } else {
                return DataRow(cells: [
                  DataCell(Text((score.key + 1).toString())),
                  DataCell(Text(score.value.playerName)),
                  DataCell(Text(score.value.weeklyScore.toString()))
                ],);
              }
            }).toList(),
          ),
        ),
      ],
    ),
  );

  Widget buildScoreListWithinCrew(GetWeeklyPlayerScoresResponse scoreResponse) => Padding(
    padding: const EdgeInsets.all(24.0),
    child: Column(
      children: [
        Expanded(
          child: DataTable(
            columns: const <DataColumn>[
              DataColumn(label: Text('Placement')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Scores')),
            ],
            rows: scoreResponse.weeklyPlayerScoresWithinCrew.asMap().entries.map((score) {
              if (score.value.playerID == playerID) {
                return DataRow(
                  // color: MaterialStateColor.resolveWith((states) => Colors.amber),
                    color: MaterialStateColor.resolveWith((states) => const Color.fromRGBO(239, 55, 62, 1.0)),
                    cells: [
                      DataCell(Text((score.key + 1).toString(),
                          style: const TextStyle(color: Colors.white))),
                      DataCell(Text(score.value.playerName,
                          style: const TextStyle(color: Colors.white))),
                      DataCell(Text(score.value.weeklyScore.toString(),
                          style: const TextStyle(color: Colors.white))),
                    ]);
              } else {
                return DataRow(cells: [
                  DataCell(Text((score.key + 1).toString())),
                  DataCell(Text(score.value.playerName)),
                  DataCell(Text(score.value.weeklyScore.toString()))
                ],);
              }
            }).toList(),
          ),
        ),
      ],
    ),
  );
}