import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:telegram_chat/pages/home_page.dart';
import 'package:telegram_chat/widgets/progress_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  bool isLoggedIn = false;
  bool isLoading = false;

  User? currentUser;
  late SharedPreferences preferences;

  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    setState(() {
      isLoggedIn = true;
    });
    preferences = await SharedPreferences.getInstance();
    isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn) {
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(currentUserID: preferences.getString("id"))));
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.lightBlueAccent, Colors.purpleAccent],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Telegram Chat",
              style: TextStyle(
                fontSize: 82,
                color: Colors.white,
                fontFamily: "DancingScript",
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: controlSignIn,
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/google.png',
                      width: 30,
                      height: 30,
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      'Sign In With Google',
                      style: TextStyle(
                          color: Colors.purple,
                          fontWeight: FontWeight.bold,
                          fontFamily: "DancingScript",
                          fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: isLoading ? circularProgress() : Container(),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> controlSignIn() async {
    log('##### Begin the function ######');
    preferences = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication? googleAuthentication =
        await googleUser!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuthentication.idToken,
        accessToken: googleAuthentication.accessToken);

    UserCredential userCredential =
        await firebaseAuth.signInWithCredential(credential);
    log('This is the UserCredential $userCredential.toString()');
    User? user = userCredential.user;

    // ** SignIn Success
    if (user != null) {
      log('######## SIGN IN SUCCESS ##########"');
      // ** Check if already SignUp
      final QuerySnapshot resultQuery = await FirebaseFirestore.instance
          .collection("users")
          .where("id", isEqualTo: user.uid)
          .get();
      final List<DocumentSnapshot> documentSnapshots = resultQuery.docs;
      // ** Save Data to firestore - if new user
      if (documentSnapshots.isEmpty) {
        FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "nickname": user.displayName,
          "photoUrl": user.photoURL,
          "id": user.uid,
          "aboutMe": 'I am Telegram Chat User',
          "createAt": DateTime.now().millisecondsSinceEpoch.toString(),
          "chattingwith": null,
        });
        // ** Write Data to Local
        currentUser = user;
        await preferences.setString("id", currentUser!.uid);
        await preferences.setString("nickname", currentUser!.displayName!);
        await preferences.setString("photoUrl", currentUser!.photoURL!);
      } else {
        // ** Write Data to Local
        currentUser = user;
        await preferences.setString("id", documentSnapshots[0]["id"]);
        await preferences.setString(
            "nickname", documentSnapshots[0]["nickname"]);
        await preferences.setString(
            "photoUrl", documentSnapshots[0]["photoUrl"]);
        await preferences.setString("aboutMe", documentSnapshots[0]["aboutMe"]);
      }
      Fluttertoast.showToast(msg: 'Congratulations, Sign in Success.');
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(currentUserID: user.uid)));
    }
    // ** SignIn Not Success - SignIn Failed
    else {
      log('######## SIGN IN FAILED ##########"');
      Fluttertoast.showToast(msg: 'Try Again, Sign in Failed.');
      setState(() {
        isLoading = false;
      });
    }
  }
}
