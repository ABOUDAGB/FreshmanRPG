import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_manager/pages/quest/bloc/quest_details_bloc.dart';
import 'package:game_manager/pages/quest/quest_landing_page.dart';

import 'package:game_manager/repository/quest/objective_completion_type_DTO.dart';

import '../../repository/quest/action_type_DTO.dart';
import '../../repository/quest/objective_record.dart';
import '../../repository/quest/quest_record.dart';
import '../../repository/quest/quest_repository.dart';

class QuestDetailsPage extends StatefulWidget {
  late QuestRecord toEdit;
  late bool willEditQuest;

  QuestDetailsPage.editQuest({Key? key, required this.toEdit}) : super(key: key) {
    willEditQuest = true;
  }

  QuestDetailsPage.newQuest({Key? key}) : super (key: key) {
    willEditQuest = false;
  }

  @override
  State<QuestDetailsPage> createState() {
    if (!willEditQuest) {
      return _QuestDetailsPageState.newQuest();
    } else {
      return _QuestDetailsPageState.editQuest(toEdit);
    }
  }
}

class _QuestDetailsPageState extends State<QuestDetailsPage> {
  final questTitle = TextEditingController();
  final experienceGained = TextEditingController();
  final questDesc = TextEditingController();
  final triggerRow = TextEditingController();
  final triggerColumn = TextEditingController();
  final fulfillmentObjectives = TextEditingController();
  final startDate = TextEditingController();
  final endDate = TextEditingController();
  final addNewQuest = TextEditingController();

  // constants for date pickers
  final DateFormat format = DateFormat("MM-dd-yyyy"); // set date format
  final DateTime earliestDate = DateTime(1000); //DateTime.now(): not to allow to choose before today.
  final DateTime latestDate = DateTime(9999, 12, 31); // latest allowed date set to December 31, 9999

  _QuestDetailsPageState.editQuest(QuestRecord toEdit) {
    questId = toEdit.id;
    populate(toEdit);
  }

  _QuestDetailsPageState.newQuest() {
    questId = -1; // if -1, a new quest is created
  }

  List<ObjectiveRecordDTO> objectivesOnScreen = [];

  int? questId;
  String? mapValue;
  int? actionValue;

  @override
  void initState() {
    super.initState();
    addNewQuest.addListener(refresh);
    // add listeners for all the text fields
    experienceGained.addListener(refresh);
    questDesc.addListener(refresh);
    triggerRow.addListener(refresh);
    triggerColumn.addListener(refresh);
    fulfillmentObjectives.addListener(refresh);
    startDate.addListener(refresh);
    endDate.addListener(refresh);
    questTitle.addListener(refresh);
  }

  // you'll probably have to change this when the time comes
  @override
  dispose() {
    super.dispose();
    // remove listeners for all the text fields
    experienceGained.removeListener(refresh);
    questDesc.removeListener(refresh);
    triggerRow.removeListener(refresh);
    triggerColumn.removeListener(refresh);
    fulfillmentObjectives.removeListener(refresh);
    startDate.removeListener(refresh);
    endDate.removeListener(refresh);
    questTitle.removeListener(refresh);
    addNewQuest.removeListener(refresh);

    addNewQuest.dispose();
    experienceGained.dispose();
    triggerRow.dispose();
    triggerColumn.dispose();
    fulfillmentObjectives.dispose();
    startDate.dispose();
    endDate.dispose();
    questTitle.dispose();
  }

  // Function to sync the password visibilities by refreshing Parent state
  refresh() {
    setState(() {});
  }

  populate(QuestRecord quest) {
    experienceGained.text = quest.xpGained.toString();
    questDesc.text = quest.description;
    triggerRow.text = quest.triggerRow.toString();
    triggerColumn.text = quest.triggerCol.toString();
    fulfillmentObjectives.text = quest.objectivesForFulfillment.toString();
    startDate.text = quest.startDate.toString();
    endDate.text = quest.endDate.toString();
    mapValue = quest.triggerMapName;
    actionValue = quest.completionActionType.actionID;
    objectivesOnScreen = quest.objectives;
    questTitle.text = quest.title;
  }

// DO NOT TAKE THIS OUT! the page will not build!
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => QuestRepository(dio: Dio()))
        ],
        child: BlocProvider<QuestDetailsBloc>(
            create: (context) =>
                QuestDetailsBloc(questRepository: context.read<QuestRepository>())
                  ..add(SendGetQuestDetailsEditingInformationEvent()),
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  title: const Text('Create/Edit a Quest'),
                  backgroundColor: Colors.pink,
                ),
                body: BlocConsumer<QuestDetailsBloc, QuestDetailsState>(
                    listener: (context, state) {
                      if (state is QuestDetailsComplete) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => QuestLandingPage(
                            questRepository: QuestRepository(dio: Dio()))));
                      }
                    },
                    builder: (context, state) {
                      return BlocBuilder<QuestDetailsBloc, QuestDetailsState>(
                          builder: (context, state) {
                        if (state is QuestDetailsPageReady) {
                           return buildInputScreen(state.response);
                        } else {
                          return buildLoadScreen();
                        }
                      });
                    }))));
  }

  Widget buildAddObjectiveButton(questResponse) => SizedBox(
    height: 100,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            iconSize: 50,
            tooltip: 'Add a new objective',
            onPressed: (){
              setState(() {
                objectivesOnScreen.add(ObjectiveRecordDTO(id: 0, description: '',
                    experiencePointsGained: 0, questID: 0, completionType: 0));
                buildObjectivesTable(questResponse.objCompletionTypes);
              });

            },
            icon: const Icon(Icons.add, color: Colors.pink),
          )
        ]
      )
    )
  );

  Widget buildLoadScreen() => const Padding(
      padding: EdgeInsets.all(24.0),
      child: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ));

  Widget buildObjectivesTable(completionTypeList) => SizedBox(
      height: 300,
      child: ListView.builder(
        itemCount: objectivesOnScreen.length,
        itemBuilder: (BuildContext context, int index){
          ObjectiveRecordDTO objective = objectivesOnScreen[index];
          return ObjectiveWidget(
            objectivesOnScreen: objectivesOnScreen,
            objectiveId: objective.id,
            questId: objective.questID,
            objectiveDescription: objective.description,
            experiencePointsGained: objective.experiencePointsGained,
            completionType: completionTypeList.firstWhere((obj) => obj.objCompletionId == objective.completionType),
            completionTypes: completionTypeList,
          );
        },
      )
  );

  // INSTRUCTIONS/NOTES:
  // To make a new component of a page (another text field or dropdown), it
  // MUST be one of the children of the Column child.
  // The dropdown menu values will all show up as "Quest Title". When we have
  // actual data that will probably change to the hint as it's supposed to.
  // I have not added a button yet. That will require a buttonbuilder and its
  // own build context. look in create_player_page for reference.
  // you should put the submit button at the bottom of the buildinputscreen

  Widget buildInputScreen(questResponse) => Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
          child: ListView(children: [
        // start putting in your page components here
        // QUEST TITLE
        TextField(
          controller: questTitle,
          decoration: InputDecoration(
            label: Row(
              children: [
                Icon(Icons.edit_note, color: Colors.pink),
                SizedBox(
                  width: 10,
                  height: 10,
                ),
                Text('Quest Title...'),
              ],
            ),
            fillColor: Colors.grey,
          ),
        ),
        // QUEST DESCRIPTION:
        TextField(
          controller: questDesc,
          decoration: InputDecoration(
            label: Row(
              children: [
                Icon(Icons.edit_note, color: Colors.pink),
                SizedBox(
                  width: 10,
                  height: 10,
                ),
                Text('Quest Description...'),
              ],
            ),
            fillColor: Colors.grey,
          ),
        ),

        // EXPERIENCE GAINED
        TextField(
          controller: experienceGained,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ], // Only numbers can be entered
          decoration: InputDecoration(
            label: Row(
              children: [
                Icon(Icons.exposure_plus_1, color: Colors.pink),
                SizedBox(
                  width: 10,
                ),
                Text('Experience Gained'),
              ],
            ),
            fillColor: Colors.grey,
          ),
        ),

        // TRIGGER MAP
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.map_outlined, color: Colors.pink)),
          hint: const Text("Trigger Map"),
          value: mapValue,
          isExpanded: true,
          onChanged: (String? value) {
            setState(() {
              mapValue = value!;
            });
          },
          items: questResponse.mapNames
              .map<DropdownMenuItem<String>>((String mapName) {
            return DropdownMenuItem<String>(
              value: mapName,
              child: Text(mapName),
            );
          }).toList(),
        ),

        // TRIGGER ROW
        TextField(
          controller: triggerRow,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ], // Only numbers can be entered
          decoration: InputDecoration(
            label: Row(
              children: [
                Icon(Icons.arrow_right_alt, color: Colors.pink),
                SizedBox(
                  width: 10,
                ),
                Text('Trigger Row'),
              ],
            ),
            fillColor: Colors.grey,
          ),
        ),

        // TRIGGER COLUMN
        TextField(
          controller: triggerColumn,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ], // Only numbers can be entered
          decoration: InputDecoration(
            label: Row(
              children: [
                Icon(Icons.arrow_right_alt, color: Colors.pink),
                SizedBox(
                  width: 10,
                ),
                Text('Trigger Column'),
              ],
            ),
            fillColor: Colors.grey,
          ),
        ),

        // FULFILLMENT OBJECTIVES
        TextField(
          controller: fulfillmentObjectives,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ], // Only numbers can be entered
          decoration: InputDecoration(
            label: Row(
              children: [
                Icon(Icons.edit_note, color: Colors.pink),
                SizedBox(
                  width: 10,
                ),
                Text('Objectives for Fulfillment'),
              ],
            ),
            fillColor: Colors.grey,
          ),
        ),

        // COMPLETION ACTION TYPE
        DropdownButtonFormField<int>(
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.incomplete_circle, color: Colors.pink)),
          hint: const Text("Completion Action Type"),
          value: actionValue,
          isExpanded: true,
          onChanged: (int? value) {
            setState(() {
              actionValue = value!;
            });
          },
          items: questResponse.completionActionTypes
              .map<DropdownMenuItem<int>>((ActionTypeDTO actions) {
            return DropdownMenuItem<int>(
              value: actions.actionID,
              child: Text(actions.actionName),
            );
          }).toList(),
        ),

        // START DATE
        TextField(
          controller: startDate,
          decoration: const InputDecoration(
            label: Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.pink),
                SizedBox(
                  width: 10,
                ),
                Text('Start Date'),
              ],
            ),
            fillColor: Colors.grey,
          ),
          readOnly: true,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: startDate.text.isEmpty ? DateTime.now() : format.parse(startDate.text), //get stored date if exists, if not get today's date
                firstDate: earliestDate,
                lastDate: latestDate
            );

            if(pickedDate != null ){
              String formattedDate = format.format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
              setState(() {
                startDate.text = formattedDate; //set formatted date to TextField value.
              });
            }
          },
        ),

        // END DATE
            TextField(
              controller: endDate,
              decoration: const InputDecoration(
                label: Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.pink),
                    SizedBox(
                      width: 10,
                    ),
                    Text('End Date'),
                  ],
                ),
                fillColor: Colors.grey,
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: endDate.text.isEmpty ? DateTime.now() : format.parse(endDate.text), //get stored date if exists, if not get today's date
                    firstDate: earliestDate,
                    lastDate: latestDate
                );

                if(pickedDate != null ){
                  String formattedDate = format.format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                  setState(() {
                    endDate.text = formattedDate; //set formatted date to TextField value.
                  });
                }
              },
            ),

        buildObjectivesTable(questResponse.objCompletionTypes),
        buildAddObjectiveButton(questResponse),
        SubmitButtonBuilder(
          questId: questId ?? -1,
          questTitle:
              addNewQuest.text.isNotEmpty ? addNewQuest.text : questTitle.text,
          questDescription: questDesc.text.isNotEmpty ? questDesc.text : null,
          objectives: objectivesOnScreen,
          xpGained: experienceGained.text.isNotEmpty
              ? int.parse(experienceGained.text)
              : 0,
          triggerMapName: mapValue,
          triggerRow:
              triggerRow.text.isNotEmpty ? int.parse(triggerRow.text) : 0,
          triggerColumn:
              triggerColumn.text.isNotEmpty ? int.parse(triggerColumn.text) : 0,
          fulfillmentObjectives: fulfillmentObjectives.text.isNotEmpty
              ? int.parse(fulfillmentObjectives.text)
              : 0,
          completionActionType: actionValue ?? 0,
          startDate: startDate.text.isNotEmpty ? startDate.text : null,
          endDate: endDate.text.isNotEmpty ? endDate.text : null,
          isEasterEgg: false,
          isValid: questTitle != null || addNewQuest.text.isNotEmpty,
        )
      ])));
}

class ObjectiveWidget extends StatefulWidget {
  ObjectiveWidget({
    Key? key,
    this.objectivesOnScreen = const [],
    this.objectiveId = -1,
    this.questId = -1,
    this.objectiveDescription = '',
    this.experiencePointsGained = 0,
    this.completionType = const ObjectiveCompletionTypeDTO(
      objCompletionId: -1,
      objCompletionName: '',
    ),
    required this.completionTypes,
  }) : super(key: key);

  final List<ObjectiveRecordDTO> objectivesOnScreen;
  final int objectiveId;
  final int questId;
  String objectiveDescription;
  int experiencePointsGained;
  ObjectiveCompletionTypeDTO? completionType;
  final List<ObjectiveCompletionTypeDTO> completionTypes;

  @override
  State<StatefulWidget> createState() => _ObjectiveWidgetState();
}

class _ObjectiveWidgetState extends State<ObjectiveWidget> {

  @override
  Widget build(BuildContext context) {
    TextEditingController objectiveDescriptionController =
        TextEditingController();
    TextEditingController experiencePointsController = TextEditingController();
    int? completionTypeValue = widget.completionType!.objCompletionId;

    objectiveDescriptionController.text = widget.objectiveDescription;
    experiencePointsController.text = widget.experiencePointsGained.toString();

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.pink),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          // Fields
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: TextField(
                controller: objectiveDescriptionController,
                decoration: const InputDecoration(
                  label: Row(children: [
                    Icon(Icons.edit_note_rounded, color: Colors.pink),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Description (Objective)'),
                  ]),
                  fillColor: Colors.grey,
                ),
                onTapOutside: (value) {
                  int index = widget.objectivesOnScreen.indexWhere((obj) => widget.objectiveId == obj.id);
                  widget.objectivesOnScreen[index].description = objectiveDescriptionController.text;
                },
              ),
            ),
            Expanded(
              child: TextField(
                controller: experiencePointsController,
                decoration: const InputDecoration(
                  label: Row(children: [
                    Icon(Icons.exposure_plus_1_rounded, color: Colors.pink),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Experience Points (Objective)'),
                  ]),
                  fillColor: Colors.grey,
                ),
                onTapOutside: (value) {
                  int index = widget.objectivesOnScreen.indexWhere((obj) => widget.objectiveId == obj.id);
                  widget.objectivesOnScreen[index].experiencePointsGained = int.parse(experiencePointsController.text);
                },
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
            Expanded(
              child: DropdownButtonFormField<ObjectiveCompletionTypeDTO>(
                decoration: const InputDecoration(
                    prefixIcon:
                        Icon(Icons.incomplete_circle, color: Colors.pink)),
                hint: const Text("Completion Type"),
                value: widget.completionType,
                isExpanded: true,
                onChanged: (ObjectiveCompletionTypeDTO? value) {
                  int index = widget.objectivesOnScreen.indexWhere((obj) => widget.objectiveId == obj.id);
                  widget.objectivesOnScreen[index].completionType = value!.objCompletionId;
                },
                items: widget.completionTypes
                    .map<DropdownMenuItem<ObjectiveCompletionTypeDTO>>(
                        (ObjectiveCompletionTypeDTO completionType) {
                  return DropdownMenuItem<ObjectiveCompletionTypeDTO>(
                    value: completionType,
                    child: Text(completionType.objCompletionName),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
                child: Row(children: [
              ElevatedButton(
                  child: const Icon(Icons.delete),
                  onPressed: () {
                      showAlertDialog(context, widget.objectiveId, widget.questId);
                  })
            ])),
          ])
        ],
      ),
    );
  }
}

// Confirmation box for deleting an objective
showAlertDialog(BuildContext context, objectiveId, questId) {
  // set up the buttons
  Widget continueButton = TextButton(
    child: const Text("Continue"),
    /* TODO: While this does send a request to delete an objective,
    *        it doesn't work. I don't believe it's an issue on the frontend.
    *        See TODO in the ObjectiveController for more details */
    onPressed:  () { BlocProvider.of<QuestDetailsBloc>(context).add(
        DeleteObjectiveEvent(objectiveId, questId));
        Navigator.pop(context);
      },
  );
  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed:  () { Navigator.pop(context); },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    content: const Text("Do you want to delete this objective?"),
    actions: [
      continueButton,
      cancelButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class SubmitButtonBuilder extends StatelessWidget {
  SubmitButtonBuilder({
    Key? key,
    this.questId = -1,
    required this.questTitle,
    this.questDescription,
    this.objectives = const [],
    this.xpGained = 0,
    this.triggerMapName,
    this.triggerRow = 0,
    this.triggerColumn = 0,
    this.fulfillmentObjectives = 0,
    this.completionActionType = 0,
    this.startDate,
    this.endDate,
    this.isEasterEgg = false,
    required this.isValid,
  }) : super(key: key);

  final int questId;
  final String? questTitle;
  final String? questDescription;
  final List<ObjectiveRecordDTO> objectives;
  final int xpGained;
  final String? triggerMapName;
  final int triggerRow;
  final int triggerColumn;
  final int fulfillmentObjectives;
  final int completionActionType;
  final String? startDate;
  final String? endDate;
  final bool isEasterEgg;

  bool isValid;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.blue,
          minimumSize: const Size(double.infinity, 50),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(1)),
          ),
        ),
        onPressed: !isValid
            ? null
            : () {
          BlocProvider.of<QuestDetailsBloc>(context).add(
              SendUpsertQuestEvent(
                  questId,
                  questTitle,
                  questDescription,
                  objectives,
                  xpGained,
                  triggerMapName,
                  triggerRow,
                  triggerColumn,
                  fulfillmentObjectives,
                  completionActionType,
                  startDate,
                  endDate,
                  isEasterEgg));
        },
        child: Text(
          (questId == -1) ? "Create Quest" : "Update Quest",
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
