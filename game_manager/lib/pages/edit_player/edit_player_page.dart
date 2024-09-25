import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_manager/pages/edit_player/bloc/edit_player_bloc.dart';
import 'package:game_manager/pages/shared/widgets/password.dart';
import 'package:game_manager/repository/crew/crew.dart';
import 'package:game_manager/repository/crew/crew_repository.dart';
import 'package:game_manager/repository/crew/get_all_crews_response.dart';
import 'package:game_manager/repository/player/player_repository.dart';
import '../../repository/player/all_players_response.dart';
import '../../repository/player/basic_response.dart';
import '../../repository/player/player.dart';
import '../shared/widgets/notification_card.dart';

class EditPlayerPage extends StatefulWidget {
  final PlayerRepository playerRepository;
  final CrewRepository crewRepository;
  const EditPlayerPage({Key? key, required this.playerRepository, required this.crewRepository}) : super(key: key);

  @override
  State<EditPlayerPage> createState() => _EditPlayerPageState();
}

class _EditPlayerPageState extends State<EditPlayerPage> {
  final passwordFirst = TextEditingController();
  final passwordConfirm = TextEditingController();
  String? playerName;
  int? crewsValue;
  bool isMatching = true;
  PasswordValidator validator = PasswordValidator();
  late PlayerRepository playerRepository;
  late CrewRepository crewRepository;


  @override
  void initState() {
    super.initState();
    passwordFirst.addListener(_checkMatch);
    passwordConfirm.addListener(_checkMatch);
    playerRepository = widget.playerRepository;
    crewRepository = widget.crewRepository;
    crewsValue = 0;
  }

  @override
  dispose() {
    super.dispose();
    passwordFirst.removeListener(_checkMatch);
    passwordConfirm.removeListener(_checkMatch);
    passwordFirst.dispose();
    passwordConfirm.dispose();
  }

  // Function to sync the password visibilities by refreshing Parent state
  refresh() {
    setState(() {});
  }

  void _checkMatch() {
    setState(() {
      isMatching = passwordFirst.text == passwordConfirm.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Edit Player'),
        ),
        body: MultiRepositoryProvider(
            providers: [
              RepositoryProvider(create: (context) => playerRepository),
              RepositoryProvider(create: (context) => crewRepository),
            ],
            child: BlocProvider<ChangePasswordBloc>(
                create: (context) => ChangePasswordBloc(
                    playerRepository: context.read<PlayerRepository>(),
                    crewRepository: context.read<CrewRepository>())..add(
                        GetPlayerNamesForPageEvent()),
                child: BlocConsumer<ChangePasswordBloc, EditPlayerState>(
                    listener: (context, state) {
                  if (state is EditPlayerComplete) {
                    if (state.response.success) {
                      playerName = null;
                      validator.isSecure = false;
                      passwordFirst.clear();
                      passwordConfirm.clear();
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: NotificationCard(
                              cardTitle:
                                  state.response.success ? "Success" : "Error",
                              description: state.response.description,
                              success: state.response.success),
                          duration: const Duration(seconds: 3),
                          behavior: SnackBarBehavior.floating,
                          padding: EdgeInsets.zero),
                    );
                  }
                }, builder: (context, state) {
                      return BlocBuilder<ChangePasswordBloc, EditPlayerState>(builder: (context, state) {
                        if (state is EditPlayerPageReady) {
                          return buildInputScreen(state.playerResponse, state.crewResponse);
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      });
                }))));
  }

  Widget buildInputScreen(AllPlayersResponse playersResponse, GetAllCrewsResponse crewsResponse) => Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
          child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceAround, // To align components with equal spacing
              mainAxisSize: MainAxisSize.max,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return DropdownMenu<String>(
                      width: constraints.maxWidth, // Set width relative to parent width
                      enableFilter: true,
                      requestFocusOnTap: true,
                      leadingIcon: const Icon(Icons.person, color: Colors.white,),
                      label: const Text('Player'),
                      inputDecorationTheme: const InputDecorationTheme(
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
                      ),
                      onSelected: (String? value) {
                        setState(() {
                          playerName = value!;
                        });
                      },
                      dropdownMenuEntries:
                      playersResponse.players.map<DropdownMenuEntry<String>>(
                            (Player player) {
                          return DropdownMenuEntry<String>(
                            value: player.playerName,
                            label: player.playerName,
                          );
                        },
                      ).toList(),
                    );
                  },
                ),

            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.diversity_3, color: Colors.white)),
              hint: const Text("Crew"),
              value: crewsValue,
              isExpanded: true,
              onChanged: (int? value) {
                setState(() {
                  crewsValue = value!;
                });
              },
              items: crewsResponse.crews
                  .map<DropdownMenuItem<int>>((Crew crew) {
                return DropdownMenuItem<int>(
                  value: crew.id,
                  child: Text(crew.name),
                );
              }).toList(),
            ),
        // Special TextField to enter new password
        PasswordField(
          controller: passwordFirst,
          validator: validator,
          notifyParent: refresh,
        ),
        // TextField to confirm password
        TextField(
          controller: passwordConfirm,
          obscureText: !validator.passwordVisible,
          decoration: InputDecoration(
            label: Row(
              children: [
                Icon(Icons.key),
                SizedBox(
                  width: 10,
                ),
                Text('Confirm Password'),
              ],
            ),
            errorText: isMatching ? null : "The two passwords do not match.",
            fillColor: Colors.grey,
          ),
        ),
        const SizedBox(
          height: 60,
        ),
        SubmitButtonBuilder(
            playerName: playerName ?? "",
            password: passwordConfirm,
            isValid: (isMatching && validator.isSecure && playerName != null),
            crewsValue: crewsValue!,)
      ])));

  Widget buildRequestCompleteScreen(BasicResponse data) =>
      Center(child: Text('$data'));
}

class SubmitButtonBuilder extends StatelessWidget {
  const SubmitButtonBuilder(
      {Key? key,
      required this.playerName,
      required this.password,
      required this.isValid,
      required this.crewsValue})
      : super(key: key);

  final String playerName;
  final TextEditingController password;
  final bool isValid;
  final int crewsValue;

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
            : () => BlocProvider.of<ChangePasswordBloc>(context)
                .add(SendChangePasswordEvent(playerName, password.text, crewsValue)),
        child: const Text(
          "Change Password",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
