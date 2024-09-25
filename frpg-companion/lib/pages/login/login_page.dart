import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/login_repository/login_repository.dart';
import '../shared_widgets/notification_card.dart';
import '../shared_widgets/password.dart';
import 'bloc/login_bloc.dart';
import '../../repository/login_repository/login_with_credentials_response.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final playerName = TextEditingController();
  final password = TextEditingController();

  bool isMatching = true;
  bool passwordVisible = false;
  PasswordValidator validator = PasswordValidator();
  final passwordFirst = TextEditingController();
  final passwordConfirm = TextEditingController();

  @override
  void initState() {
    super.initState();
    passwordFirst.addListener(_checkMatch);
    passwordConfirm.addListener(_checkMatch);
    passwordVisible = false;
  }

  @override
  dispose() {
    super.dispose();
    playerName.dispose();
    password.dispose();

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
          backgroundColor: const Color.fromRGBO(0, 22, 65, 1.0),
          title: const Text('Login', style: TextStyle(
            color: Colors.white,
          )),
        ),
        body: RepositoryProvider(
            create: (context) => LoginRepository(),
            child: BlocProvider<LoginBloc>(
                create: (context) =>
                    LoginBloc(
                        context: context,
                        loginRepository: context.read<LoginRepository>()),
                child: BlocConsumer<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state is LoginFailed) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: NotificationCard(
                                cardTitle: "Login Failed",
                                description: "Please try again",
                                success: state.response.success
                            ),
                            duration: const Duration(seconds: 3),
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.only(
                                bottom: MediaQuery
                                    .of(context)
                                    .size
                                    .height - 450
                            ),
                            padding: EdgeInsets.zero,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is LoginComplete) {
                        return buildRequestCompleteScreen(state.response);
                      } else {
                        return buildInputScreen(context);
                      }
                    })
            )
        )
    );
  }

  void submitForm(BuildContext context) {
    if (formKey.currentState!.validate()) {
      BlocProvider.of<LoginBloc>(context).add(SendLoginEvent(
        playerName.text,
        password.text,
      ));
    }
  }

  Widget buildInputScreen(BuildContext context) =>
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Center(
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (fieldText) {
                        if (fieldText == null || fieldText.isEmpty) {
                          return "Username field is empty";
                        }
                        return null;
                      },
                      controller: playerName,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        label: const Row(
                          children: [
                            Icon(Icons.person),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Username'),
                          ],
                        ),
                        filled: true,
                        fillColor: const Color.fromRGBO(200, 200, 200, 0.5),
                      ),
                    ),

                    const Text("Only Ship username (without @ship.edu)."),
                    const SizedBox(height: 10),

                    TextFormField(
                      onFieldSubmitted: (fieldText) {
                        submitForm(context);
                      },
                      validator: (fieldText) {
                        if (fieldText == null || fieldText.isEmpty) {
                          return "Password field is empty";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      obscureText: !passwordVisible,
                      controller: password,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              passwordVisible ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            }),
                        label: Row(
                          children: [
                            Icon(Icons.key),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Password',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        filled: true,
                        fillColor: const Color.fromRGBO(200, 200, 200, 0.5),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    SubmitButtonBuilder(
                        playerName: playerName,
                        password: password,
                        loginPageState: this),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 30),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      child: const Text(
                        "Forgot Password",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () => _dialogBuilderResetPassword(context),
                    ),
                    const Text("For login help, contact frpgadmin@engr.ship.edu."),
                  ],
                ),
              ),

              const Image(
                  image: AssetImage("assets/ship-logo.png")
              )
            ],
          ),
        ),
      );

  Widget buildRequestCompleteScreen(LoginWithCredentialsResponse data) =>
      Center(child: Text('$data'));

  /**
   * Builds "Reset Password" popup
   */
  Future<void> _dialogBuilderResetPassword(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Reset Password"),
              content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: double.infinity,
                      height: 150,
                      child: Form(
                          child: Column(
                              children: <Widget>[
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Username',
                                    icon: Icon(Icons.account_box),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 16.0),
                                ),
                                ElevatedButton(
                                  child: const Text(
                                      "Reset",
                                      style: TextStyle(color: Colors.black)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        _dialogBuilderVerificationCode(context);
                                      }
                                  //todo: needs to sendPasswordResetCodeRequest and verify the username
                                )
                              ]
                          )
                      )
                  )
              )
          );
        }
    );
  }


  /**
   * builds "Verification Code" popup
   */
  Future<void> _dialogBuilderVerificationCode(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("User Authentication"),
              content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: double.infinity,
                      height: 200,
                      child: Form(
                          child: Column(
                              children: <Widget>[
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Code',
                                    icon: Icon(Icons.account_box),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 16.0),
                                ),
                                ElevatedButton(
                                  child: const Text(
                                      "Done",
                                      style: TextStyle(color: Colors.black)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _dialogBuilderChangePassword(context);
                                  }
                                  //todo: needs to verify that the code that was inputted matches the one in the DB (will be a request)
                                )
                              ]
                          )
                      )
                  )
              )
          );
        }
    );
  }

  /**
   * Builds "Change Password" popup
   */
  Future<void> _dialogBuilderChangePassword(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Change Password"),
              content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: double.infinity,
                      height: 250,
                      child: Form(
                          child: Column(
                              children: <Widget>[
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
                                    label: const Row(
                                      children: [
                                        Icon(Icons.key),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text('Confirm Password'),
                                      ],
                                    ),
                                    errorText: isMatching
                                        ? null
                                        : "The two passwords do not match.",
                                    fillColor: Colors.grey,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 16.0),
                                ),
                                ElevatedButton(
                                  child: const Text(
                                      "Submit",
                                      style: TextStyle(color: Colors.black)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    //todo: needs to submit a change password request and close all popups
                                  },
                                )
                              ]
                          )
                      )
                  )
              )
          );
        }
    );
  }
}

class SubmitButtonBuilder extends StatelessWidget {
  const SubmitButtonBuilder({
    Key? key,
    required this.playerName,
    required this.password,
    required this.loginPageState,
  }) : super(key: key);

  final TextEditingController playerName;
  final TextEditingController password;
  final _LoginPageState loginPageState;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromRGBO(239, 55, 62, 1.0),
          minimumSize: const Size(double.infinity, 60),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        onPressed: () {
          loginPageState.submitForm(context);
        },
        child: const Text(
          "Login",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
