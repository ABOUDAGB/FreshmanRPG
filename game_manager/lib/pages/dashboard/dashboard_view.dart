import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:game_manager/pages/dashboard/widgets/navigation_card.dart';
import 'package:game_manager/pages/create_player/create_player_page.dart';
import 'package:game_manager/pages/edit_player/edit_player_page.dart';
import 'package:game_manager/pages/quest/quest_details_page.dart';
import 'package:game_manager/repository/crew/crew_repository.dart';
import 'package:game_manager/repository/player/player_repository.dart';
import 'package:game_manager/repository/quest/quest_repository.dart';

import '../crews/crews_page.dart';
import '../quest/quest_landing_page.dart';
import '../questions/questions_page.dart';


class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(12),
        child: ListView(
          shrinkWrap: true,
          children: [
            const NavigationCard(
              cardTitle: 'Create Player',
              cardIcon: Icon(Icons.accessibility_new_rounded),
              cardLink: CreatePlayerPage(),
            ),
            NavigationCard(
              cardTitle: 'Edit Player',
              cardIcon: const Icon(Icons.lock_open),
              cardLink: EditPlayerPage(playerRepository: PlayerRepository(dio: Dio()), crewRepository: CrewRepository(dio: Dio()),),
            ),
            NavigationCard(
              cardTitle: 'Create/Edit a Quest',
              cardIcon: Icon(Icons.assignment_add),
              cardLink: QuestLandingPage(questRepository: QuestRepository(dio: Dio())),
            ),
            NavigationCard(
              cardTitle: 'Crews',
              cardIcon: Icon(Icons.groups),
              cardLink: CrewsPage(crewRepository: CrewRepository(dio: Dio()),),
            ),
            const NavigationCard(
              cardTitle: 'QuizBot',
              cardIcon: Icon(Icons.quiz),
              cardLink: QuestionsPage(), //TODO: Edit proper linking for QuizBot
            ),

          ],
        ),
      ),
    );
  }
}

