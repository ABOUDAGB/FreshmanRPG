import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_manager/pages/quest/quest_details_page.dart';
import 'package:game_manager/repository/quest/quest_editing_response.dart';
import 'package:game_manager/repository/quest/quest_record.dart';
import 'package:game_manager/repository/quest/quest_repository.dart';
import '../dashboard/widgets/navigation_card.dart';
import 'bloc/quest_landing_bloc.dart';

class QuestLandingPage extends StatefulWidget {
  final QuestRepository questRepository;

  const QuestLandingPage({Key? key, required this.questRepository})
      : super(key: key);

  @override
  State<QuestLandingPage> createState() => _QuestLandingPageState();
}

class _QuestLandingPageState extends State<QuestLandingPage> {
  late QuestRepository questRepository;
  late List<TextEditingController> controllers;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    //todo make the edit controller work
    // controllers = crews.map((crew) => TextEditingController(text: crew)).toList();
    questRepository = widget.questRepository;
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => QuestRepository(dio: Dio())),
        ],
        child: MultiBlocProvider(
            providers: [
              BlocProvider<QuestLandingBloc>(
                  create: (context) => QuestLandingBloc(
                      questRepository: context.read<QuestRepository>())),
            ],
            child: Scaffold(
                appBar: AppBar(
                  title: const Center(child: Text('Quests')),
                  backgroundColor: Colors.deepPurple,
                  surfaceTintColor: Colors.deepPurple,
                ),
                body: RepositoryProvider(
                    create: (context) => questRepository,
                    child: BlocProvider<QuestLandingBloc>(
                        create: (context) => QuestLandingBloc(
                            questRepository: questRepository)
                          ..add(SendGetQuestLandingEditingInformationEvent()),
                        // todo will this work?
                        child:
                            BlocConsumer<QuestLandingBloc, QuestLandingState>(
                                listener: (context, state) {},
                                builder: (context, state) {
                                  return BlocBuilder<QuestLandingBloc,
                                          QuestLandingState>(
                                      builder: (context, state) {
                                    if (state is QuestLandingPageReady) {
                                      return buildInputScreen(state.response);
                                    } else {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                  });
                                }))))));
  }

  Widget buildInputScreen(QuestEditingDataResponse questResponse) => Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Expanded(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                margin: const EdgeInsets.only(bottom: 24.0),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: scrollController,
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: questResponse.quests.length,
                    itemBuilder: (context, index) {
                      return Container(
                          decoration: BoxDecoration(
                            color: (index % 2 == 0) ? Colors.black54 : null,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        child: ListTile(
                            title: Row(children: [
                              Expanded(
                                child: Text(questResponse.quests[index].title),
                              ),
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => QuestDetailsPage.editQuest(
                                              toEdit: questResponse.quests[index])),
                                    );
                                  }),
                              IconButton(
                                  icon: const Icon(Icons.delete_forever),
                                  onPressed: () {
                                    BlocProvider.of<QuestLandingBloc>(context).add(
                                        SendQuestRemoveEvent(questResponse.quests[index].id));
                                  }),
                            ]))
                      );
                    },
                  ),
                ),
              ),
            ),
           SizedBox(
             width: double.infinity,
             height: 70,
             child: ElevatedButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
            ),
            child: const Text('Create New Quest'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuestDetailsPage.newQuest()),
              );
            },
          ),
           ),
        ],
      ));
}

// IconButton(
//   icon: Icon(Icons.delete),
//   onPressed: () {
//     showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//
//           title: Text('Are you sure you want to delete ${crewsResponse.crews[index]}?'),
//
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 //TODO: Delete from database
//                 print('Delete ${crewsResponse.crews[index]}');
//                 // This removes the crew from visibility
//                 setState(() {
//                   crewsResponse.crews.removeAt(index);
//
//                 });
//                 Navigator.pop(context);
//               },
//               child: Text('Confirm'),
//             ),
//           ],
//         ),
//     );
//   },
// ),
