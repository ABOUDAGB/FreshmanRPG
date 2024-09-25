import 'package:flutter/material.dart';
import 'package:game_manager/pages/crews/bloc/crews_bloc.dart';
import 'package:game_manager/repository/crew/crew.dart';
import 'package:game_manager/repository/crew/crew_repository.dart';
import 'package:game_manager/pages/shared/widgets/notification_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/crew/get_all_crews_response.dart';

class CrewsPage extends StatefulWidget {
  final CrewRepository crewRepository;
  const CrewsPage({Key? key, required this.crewRepository}) : super(key: key);

  @override
  State<CrewsPage> createState() => _CrewsPageState();
}

class _CrewsPageState extends State<CrewsPage> {
  late CrewRepository crewRepository;
  late List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    //todo make the edit controller work
    // controllers = crews.map((crew) => TextEditingController(text: crew)).toList();
    crewRepository = widget.crewRepository;
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => CrewRepository(dio: Dio())),
        ],
        child: MultiBlocProvider(
            providers: [
              BlocProvider<CrewsBloc>(
                  create: (context) =>
                      CrewsBloc(
                          crewRepository: context.read<CrewRepository>())
              ),
            ],
            child: Scaffold(
                appBar: AppBar(
                  title: const Center(child: Text('Crews')),
                ),
                body: RepositoryProvider(
                    create: (context) => crewRepository,
                    child: BlocProvider<CrewsBloc>(
                        create: (context) =>
                        CrewsBloc(crewRepository: crewRepository)
                          ..add(
                              GetCrewsForPageEvent()),
                        child: BlocConsumer<CrewsBloc, CrewsState>(
                            listener: (context, state) {
                              if (state is CrewsComplete) {
                                if (state.response.success) {
                                  // list view code here todo
                                  //this should be crewscomplete and related code, crewsready is the next section
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: NotificationCard(
                                          cardTitle:
                                          state.response.success
                                              ? "Success"
                                              : "Error",
                                          description: state.response
                                              .toString(),
                                          //TODO: check that this works
                                          success: state.response.success),
                                      duration: const Duration(seconds: 3),
                                      behavior: SnackBarBehavior.floating,
                                      padding: EdgeInsets.zero),
                                );
                              }
                            }, builder: (context, state) {
                          return BlocBuilder<CrewsBloc, CrewsState>(
                              builder: (context, state) {
                                if (state is CrewsPageReady) {
                                  return buildInputScreen(state.response);
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              });
                        }))))));
  }
  Widget buildInputScreen(GetAllCrewsResponse crewsResponse) => Padding(
    padding: const EdgeInsets.all(24.0),
    child: ListView.builder(
        itemCount: crewsResponse.crews.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(crewsResponse.crews[index].name),
                ),
                // IconButton(
                //   icon: Icon(Icons.edit),
                //   onPressed: () {
                //     showDialog(
                //       context: context,
                //       builder: (context) => AlertDialog(
                //         title: Text('Edit Crew Name'),
                //         content: TextField(
                //           controller: controllers[index],
                //         ),
                //         actions: [
                //           TextButton(
                //             onPressed: () {
                //               Navigator.pop(context);
                //             },
                //             child: Text('Cancel'),
                //           ),
                //           TextButton(
                //             onPressed: () {
                //               //TODO: Edit crew name in database and display it
                //               //currently, clicking cancel and re-editing will keep the
                //               //new name of the crew in the text field.
                //               print('Edit ${crewsResponse.crews[index]}');
                //
                //               setState(() {
                //                 crewsResponse.crews[index] = controllers[index].text as Crew;
                //               });
                //               Navigator.pop(context);
                //             },
                //             child: Text('Save'),
                //           ),
                //         ],
                //       ),
                //     );
                //   },
                // ),
                //
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
              ],
            ),
          );
        },
      ),
    );

  }