import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_manager/pages/quest/bloc/quest_details_bloc.dart';
import 'package:game_manager/repository/quest/objective_completion_type_DTO.dart';

import '../../repository/quest/action_type_DTO.dart';
import '../../repository/quest/objective_record.dart';
import '../../repository/quest/quest_record.dart';
import '../../repository/quest/quest_repository.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({Key? key}) : super(key: key);

  @override
  State<QuestionsPage> createState() => _QuestionsPage();
}

class _NPCQuestions {
  int npcID = 0;
  String npcName = "NPC1";
  List<List<String>> options = [];

  _NPCQuestions(int npcID, String npcName, List<List<String>> options) {
    this.npcID = npcID;
    this.npcName = npcName;
    this.options = options;
  }

}

class _QuestionsPage extends State<QuestionsPage> {
  String? npcName;
  List<_NPCQuestions> npcList = [
    _NPCQuestions(1, "Bobby", [
      ['Question 1', 'Answer 1', 'Start Date 1', 'End Date 1'],
      ['Question 2', 'Answer 2', 'Start Date 2', 'End Date 2'],
      ['Question 3', 'Answer 3', 'Start Date 3', 'End Date 3'],
      ['Question 4', 'Answer 4', 'Start Date 4', 'End Date 4'],
      ['Question 5', 'Answer 5', 'Start Date 5', 'End Date 5'],
    ]),
    _NPCQuestions(2, "Fred", [
      ['Question 1F', 'Answer 1F', 'Start Date 1F', 'End Date 1F'],
      ['Question 2F', 'Answer 2F', 'Start Date 2F', 'End Date 2F'],
      ['Question 3F', 'Answer 3F', 'Start Date 3F', 'End Date 3F'],
      ['Question 4F', 'Answer 4F', 'Start Date 4F', 'End Date 4F'],
      ['Question 5F', 'Answer 5F', 'Start Date 5F', 'End Date 5F'],
    ])
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Center(child: Text('QuizBot')),
      ),
      body: Column(
        children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person, color: Colors.black),
            ),
            hint: Text("NPCs"),
            value: npcName,
            isExpanded: true,
            onChanged: (String? selectedNPC) {
              setState(() {
                 npcName = selectedNPC!;
              });
            },
            items: npcList.map<DropdownMenuItem<String>>((npc) {
              return DropdownMenuItem<String>(
                value: npc.npcName,
                child: Text(npc.npcName), // Display NPC name as dropdown item
              );
            }).toList(),

          ),

          // DropdownButtonFormField<String>( // Added String type parameter
          //   decoration: InputDecoration(
          //     prefixIcon: Icon(Icons.person, color: Colors.black),
          //   ),
          //   hint: Text("NPCs"),
          //   value: npcList != null && npcList.isNotEmpty ? npcList[0] : null,
          //   items: npc != null ? npc.map((String value) {
          //     return DropdownMenuItem<String>(
          //       value: value,
          //       child: Text(value),
          //     );
          //   }).toList() : [],
          //
          //   onChanged: (String? value) {
          //     setState(() {
          //       npcList = [value!];
          //     });
          //   },
          // ),
          Expanded(
            child: ListView.builder(
              itemCount: npcList[0].options.length,
              itemBuilder: (context, selectedNPC) {
                return ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(npcList[0].options[selectedNPC][0]),
                      ),
                      Expanded(
                        child: Text(npcList[0].options[selectedNPC][1]),
                      ),
                      Expanded(
                        child: Text(npcList[0].options[selectedNPC][2]),
                      ),
                      Expanded(
                        child: Text(npcList[0].options[selectedNPC][3]),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
