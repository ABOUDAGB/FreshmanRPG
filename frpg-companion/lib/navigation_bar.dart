import 'package:companion_app/pages/high_score/high_score_page.dart';
import 'package:companion_app/pages/objectives-list/objectives_list_page.dart';
import 'package:companion_app/repository/shared_repository_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'repository/score_repository/score_repository.dart';


class NavigationBarApp extends StatefulWidget {
  const NavigationBarApp(this.playerId, this.authKey, {Key? key})
      : super(key: key);
  final int playerId;
  final String authKey;

  @override
  State<NavigationBarApp> createState() => _NavigationBarAppState(playerId, authKey);
}

class _NavigationBarAppState extends State<NavigationBarApp> {
  int currentPageIndex = 0;
  final int playerId;
  final String authKey;

  _NavigationBarAppState(this.playerId, this.authKey) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        currentIndex: currentPageIndex,
        backgroundColor: const Color.fromRGBO(0, 22, 65, 1.0),
        // Change this too to keep label white
        selectedItemColor: Colors.white,
        // selectedItemColor: const Color.fromRGBO(239, 55, 62, 1.0),
        unselectedItemColor: Colors.white,
        // CHANGE THIS TO MAKE IT ONLY THE ICON FILLED IN, LABEL STAYS WHITE
        selectedIconTheme: const IconThemeData(color: Color.fromRGBO(239, 55, 62, 1.0)),
        selectedFontSize: 16.0,
        unselectedFontSize: 14.0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Objectives',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'High Scores',
          ),
        ],
      ),
      body: <Widget>[
        /// Home page
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(0),
          child: SizedBox.expand(
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: ObjectivesListView(
                navContext: context,
                playerId: playerId,
                authKey: authKey,
              ),
            ),
          ),
        ),

        /// High score page
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(0.0),
          child: SizedBox.expand(
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: HighScorePage(
                playerId,
                scoreRepository: ScoreRepository(
                  dio: Dio(BaseOptions(baseUrl: SharedRepositoryState().findBaseURL())),
                ),
              ),
            ),
          ),
        ),
      ][currentPageIndex],
    );

    //   bottomNavigationBar: NavigationBar(
    //     backgroundColor: const Color.fromRGBO(0, 22, 65, 1.0),
    //     onDestinationSelected: (int index) {
    //         setState(() {
    //           currentPageIndex = index;
    //         });
    //     },
    //     indicatorColor: Colors.amber,
    //     selectedIndex: currentPageIndex,
    //     destinations: const <Widget>[
    //       NavigationDestination(
    //         icon: Icon(Icons.home_outlined, color: Colors.white),
    //         selectedIcon: Icon(Icons.home, color: Color.fromRGBO(0, 22, 65, 1.0)),
    //         label: 'Objectives',
    //
    //       ),
    //       NavigationDestination(
    //         icon: Icon(Icons.leaderboard_outlined, color: Colors.white),
    //         selectedIcon: Icon(Icons.leaderboard_outlined, color: Color.fromRGBO(0, 22, 65, 1.0)),
    //         label: 'High Scores',
    //       ),
    //     ],
    //   ),
    //   body: <Widget>[
    //     /// Home page
    //     Card(
    //       shadowColor: Colors.transparent,
    //       margin: const EdgeInsets.all(0),
    //       child: SizedBox.expand(
    //         child:MaterialApp(
    //           debugShowCheckedModeBanner: false,
    //           home: ObjectivesListView(navContext: context, playerId: playerId, authKey: authKey),
    //         ),
    //       ),
    //     ),
    //
    //     /// High score page
    //     Card(
    //       shadowColor: Colors.transparent,
    //       margin: const EdgeInsets.all(0.0),
    //       child: SizedBox.expand(
    //         child:MaterialApp(
    //           debugShowCheckedModeBanner: false,
    //           home: HighScorePage(playerId,
    //             scoreRepository: ScoreRepository(
    //               dio: Dio(BaseOptions(baseUrl: SharedRepositoryState().findBaseURL()))))),
    //       ),
    //     ),
    //
    //   ][currentPageIndex],
    // );
  }
}
