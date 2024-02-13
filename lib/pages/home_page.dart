import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:telegram_chat/pages/account_settings_page.dart';
import 'package:telegram_chat/widgets/progress_widget.dart';

import '../models/user.dart';

class HomeScreen extends StatefulWidget {
  final String? currentUserID;
  const HomeScreen({super.key, required this.currentUserID});

  @override
  // ignore: no_logic_in_create_state
  State<HomeScreen> createState() =>
      _HomeScreenState(currentUserID: currentUserID);
}

class _HomeScreenState extends State<HomeScreen> {
  _HomeScreenState({required this.currentUserID});

  TextEditingController searchTextEditingController = TextEditingController();
  emptyTestformField() {
    searchTextEditingController.clear();
  }

  Future<QuerySnapshot>? futureSearchResults;

  final String? currentUserID;

  homePageHeader() {
    return AppBar(
        automaticallyImplyLeading: false, //Remove the Back Button
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsPage()));
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
                fillColor: Colors.lightBlue,
                hintText: "Search here ...",
                hintStyle: const TextStyle(color: Colors.white),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
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
            onFieldSubmitted: controlSearching,
          ),
        ));
  }

  controlSearching(String userName) {
    Future<QuerySnapshot> allFoundUsers = FirebaseFirestore.instance
        .collection("users")
        .where("nickname", isGreaterThanOrEqualTo: userName)
        .get();

    setState(() {
      futureSearchResults = allFoundUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: homePageHeader(),
      body: futureSearchResults == null
          ? displayNoSearchResultScreen()
          : displayUserFoundScreen(),
    );
  }

  displayNoSearchResultScreen() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: const [
            Icon(Icons.group, color: Colors.lightBlueAccent, size: 200.0),
            Text(
              'Search Users',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.lightBlueAccent,
                fontSize: 50.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  displayUserFoundScreen() {
    return FutureBuilder(
      future: futureSearchResults,
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgress();
        }
        List<UserResult> searchUserResult = [];
        for (var document in dataSnapshot.data!.docs) {
          User eachUser = User.fromDocument(document);
          UserResult userResult = UserResult(eachUser: eachUser);

          if (currentUserID != document['id']) {
            searchUserResult.add(userResult);
          }
        }
        return ListView(
          children: searchUserResult,
        );
      },
    );
  }
}

class UserResult extends StatelessWidget {
  final User eachUser;
  const UserResult({super.key, required this.eachUser});

  @override
  Widget build(BuildContext context) {
    String joinedDate = DateFormat("dd MMMM, yyyy - hh:mm:aa").format(
      DateTime.fromMillisecondsSinceEpoch(
        int.parse(eachUser.createAt),
      ),
    );
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            GestureDetector(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.black,
                  backgroundImage:
                      CachedNetworkImageProvider(eachUser.photoUrl),
                ),
                title: Text(
                  eachUser.nickname,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Joined: $joinedDate",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
