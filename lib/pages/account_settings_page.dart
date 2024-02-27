import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telegram_chat/widgets/progress_widget.dart';

import '../main.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.lightBlue,
        title: const Text(
          "Account Settings",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: const SafeArea(child: SettingsScreen()),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController? nickNameTextEditingController;
  TextEditingController? aboutMeTextEditingController;

  late SharedPreferences preferences;
  String id = "";
  String nickname = "";
  String aboutMe = "";
  String photoUrl = "";

  File? imageFileAvatar;
  bool isLoading = false;

  final FocusNode nickNameFocusNode = FocusNode();
  final FocusNode aboutMeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    readDataFromLocal();
  }

  void readDataFromLocal() async {
    preferences = await SharedPreferences.getInstance();
    id = preferences.getString("id") ?? "";
    nickname = preferences.getString("nickname") ?? "";
    photoUrl = preferences.getString("photoUrl") ?? "";
    aboutMe = preferences.getString("aboutMe") ?? "";

    nickNameTextEditingController = TextEditingController(text: nickname);
    aboutMeTextEditingController = TextEditingController(text: aboutMe);
    setState(() {});
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? newImageFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    // ignore: unnecessary_null_comparison
    if (newImageFile != null) {
      setState(() {
        imageFileAvatar = File(newImageFile.path);
        isLoading = true;
      });
    }
    // upload Image To Firestore and Storage
    uploadImageToFirestoreandStorage();
  }

  Future uploadImageToFirestoreandStorage() async {
    String mFileName = id;
    Reference storageReference =
        FirebaseStorage.instance.ref().child(mFileName);

    UploadTask storageUploadTask = storageReference.putFile(imageFileAvatar!);

    TaskSnapshot storageTaskSnapshot;
    storageUploadTask.whenComplete(() {}).then((TaskSnapshot snapshot) {
      storageTaskSnapshot = snapshot;
      return storageTaskSnapshot.ref.getDownloadURL();
    }).then((String downloadUrl) {
      photoUrl = downloadUrl;
      FirebaseFirestore.instance.collection("users").doc(id).update({
        "photoUrl": photoUrl,
        "nickname": nickname,
        "aboutMe": aboutMe,
      }).then((data) async {
        await preferences.setString("photoUrl", photoUrl);
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: "Updated Successfully.");
      });
    }).catchError((errorMsg) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Error occured in getting Download URL.");
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: error.toString());
    });
  }

  void updateData() {
    log("########### Update Function Called ############");
    nickNameFocusNode.unfocus();
    aboutMeFocusNode.unfocus();
    setState(() {
      isLoading = false;
    });
    FirebaseFirestore.instance.collection("users").doc(id).update({
      "photoUrl": photoUrl,
      "nickname": nickname,
      "aboutMe": aboutMe,
    }).then((data) async {
      await preferences.setString("photoUrl", photoUrl);
      await preferences.setString("nickname", nickname);
      await preferences.setString("aboutMe", aboutMe);
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Updated Successfully.");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(20.0),
                child: Center(
                  child: Stack(
                    children: [
                      // ignore: unnecessary_null_comparison
                      (imageFileAvatar == null)
                          ? (photoUrl != "")
                              ? Material(
                                  // Display already existing -old image file
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(125.0),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  // Display already existing -old image file
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.lightBlueAccent),
                                    ),
                                    imageUrl: photoUrl,
                                    width: 200.0,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(
                                  Icons.account_circle,
                                  size: 90.0,
                                  color: Colors.grey,
                                )
                          : Material(
                              // Display The new Updated image here
                              borderRadius: const BorderRadius.all(
                                Radius.circular(125.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                              // Display The new Updated image here
                              child: Image.file(
                                imageFileAvatar!,
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                      IconButton(
                        onPressed: getImage,
                        icon: const Icon(
                          Icons.camera_alt,
                          size: 100.0,
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(50),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.grey,
                        iconSize: 200.0,
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: isLoading ? circularProgress() : Container(),
                  ),
                  // UserName
                  Container(
                    margin: const EdgeInsets.only(
                        left: 10.0, bottom: 5.0, top: 10.0),
                    child: const Text(
                      "Profile Name :",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: Colors.lightBlueAccent),
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: "e.g Meriem ",
                          contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        controller: nickNameTextEditingController,
                        onChanged: (value) {
                          nickname = value;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 10.0, bottom: 5.0, top: 10.0),
                    child: const Text(
                      "About Me :",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: Colors.lightBlueAccent),
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: "e.g Im ... ",
                          contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        controller: aboutMeTextEditingController,
                        onChanged: (value) {
                          aboutMe = value;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Buttons
                  ElevatedButton(
                    onPressed: updateData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors
                          .lightBlueAccent, // Change the background color here
                    ),
                    child: const Text(
                      "Update",
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: logoutUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.red, // Change the background color here
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();
  Future<Null> logoutUser() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    setState(() {
      isLoading = false;
    });
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MyApp()),
        (Route<dynamic> route) => false);
  }
}
