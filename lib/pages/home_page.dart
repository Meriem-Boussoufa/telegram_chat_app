import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:telegram_chat/main.dart';
import 'package:telegram_chat/pages/account_settings_page.dart';

class HomeScreen extends StatefulWidget {
  final String? currentUserID;
  const HomeScreen({super.key, required this.currentUserID});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchTextEditingController = TextEditingController();
  emptyTestformField() {
    searchTextEditingController.clear();
  }

  homePageHeader() {
    return AppBar(
        automaticallyImplyLeading: false, //Remove the Back Button
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Settings()));
            },
            icon: const Icon(
              Icons.settings,
              size: 30.0,
              color: Colors.white,
            ),
          )
        ],
        backgroundColor: Colors.lightBlue,
        title: Container(
          margin: const EdgeInsets.only(bottom: 4.0),
          child: TextFormField(
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
            controller: searchTextEditingController,
            decoration: InputDecoration(
                hintText: "Search here ...",
                hintStyle: const TextStyle(color: Colors.white),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                filled: true,
                prefixIcon: const Icon(
                  Icons.person_pin,
                  color: Colors.white,
                  size: 30.0,
                ),
                suffixIcon: IconButton(
                    onPressed: emptyTestformField,
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.white,
                    ))),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homePageHeader(),
      body: ElevatedButton.icon(
        onPressed: logoutUser,
        icon: const Icon(Icons.close),
        label: const Text("Sign Out"),
      ),
    );
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();
  Future<Null> logoutUser() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MyApp()),
        (Route<dynamic> route) => false);
  }
}
