import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telegram_chat/widgets/progress_widget.dart';

class Chat extends StatefulWidget {
  final String receiverId;
  final String receiveravatar;
  final String receiverName;
  const Chat(
      {super.key,
      required this.receiverId,
      required this.receiveravatar,
      required this.receiverName});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.black,
              backgroundImage:
                  CachedNetworkImageProvider(widget.receiveravatar),
            ),
          )
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.receiverName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ChatScreen(
            receiverId: widget.receiverId,
            receiverAvatar: widget.receiveravatar),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverAvatar;
  const ChatScreen(
      {super.key, required this.receiverId, required this.receiverAvatar});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController textEditingController = TextEditingController();

  final ScrollController listscrollController = ScrollController();

  final FocusNode focusNode = FocusNode();
  bool isDisplaySticker = false;
  bool? isLoading;

  File? imageFile;
  String? imageUrl;

  String? chatId;
  SharedPreferences? preferences;
  String? id;

  var listMessages;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
    isDisplaySticker = false;
    isLoading = false;

    chatId = "";
    readLocal();
  }

  readLocal() async {
    preferences = await SharedPreferences.getInstance();
    id = preferences!.getString("id") ?? "";

    if (id.hashCode <= widget.receiverId.hashCode) {
      chatId = '$id-$widget.receiverId';
    } else {
      chatId = '$widget.receiverId-$id';
    }
    FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({'chattingwith': widget.receiverId});
    setState(() {});
  }

  onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide Stickers whenever keyboard appears
      setState(() {
        isDisplaySticker = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Create List of Messages
              Expanded(
                child: createListMessages(),
              ),
              // Show Stickers
              (isDisplaySticker ? createStickers() : Container()),
              // Input controllers
              createInput(),
            ],
          ),
          createLoading(),
        ],
      ),
      onPopInvoked: (didPop) {
        if (!didPop && isDisplaySticker) {
          setState(() {
            isDisplaySticker = true;
          });
        }
      },
    );
  }

  createLoading() {
    return Positioned(
      child: isLoading! ? circularProgress() : Container(),
    );
  }

  createStickers() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
        color: Colors.white,
      ),
      height: 170.0,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        // ** First Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () => onSendMessage("mim", 2),
                child: Image.asset(
                  'assets/images/stickers/mim.jpeg',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )),
            ElevatedButton(
                onPressed: () => onSendMessage("mim1", 2),
                child: Image.asset(
                  'assets/images/stickers/mim1.jpeg',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )),
            ElevatedButton(
                onPressed: () => onSendMessage("mim2", 2),
                child: Image.asset(
                  'assets/images/stickers/mim2.jpeg',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )),
          ],
        ),
        // ** Second Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () => onSendMessage("mim2", 2),
                child: Image.asset(
                  'assets/images/stickers/mim2.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )),
            ElevatedButton(
                onPressed: () => onSendMessage("mim3", 2),
                child: Image.asset(
                  'assets/images/stickers/mim3.gif',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )),
            ElevatedButton(
                onPressed: () => onSendMessage("mim3", 2),
                child: Image.asset(
                  'assets/images/stickers/mim3.jpeg',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )),
          ],
        ),
        // ** Third Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () => onSendMessage("mim4", 2),
                child: Image.asset(
                  'assets/images/stickers/mim4.jpeg',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )),
            ElevatedButton(
                onPressed: () => onSendMessage("mim5", 2),
                child: Image.asset(
                  'assets/images/stickers/mim5.jpeg',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )),
            ElevatedButton(
                onPressed: () => onSendMessage("mim6", 2),
                child: Image.asset(
                  'assets/images/stickers/mim6.jpeg',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )),
          ],
        ),
      ]),
    );
  }

  void getSticker() {
    focusNode.unfocus();
    setState(() {
      isDisplaySticker = !isDisplaySticker;
      log("####### User Demand Stickers Container : $isDisplaySticker");
    });
  }

  createListMessages() {
    return Flexible(
      child: chatId == ""
          ? const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
              ),
            )
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("messages")
                  .doc(chatId)
                  .collection(chatId!)
                  .orderBy("timestamp", descending: true)
                  .limit(20)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                    ),
                  );
                } else {
                  listMessages = snapshot.data!.docs;
                  return ListView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemCount: snapshot.data!.docs.length,
                    reverse: true,
                    controller: listscrollController,
                    itemBuilder: (context, index) {
                      //createItem(index, snapshot.data!.docs[index]);
                    },
                  );
                }
              },
            ),
    );
  }

  createItem() {}

  createInput() {
    return Container(
      width: double.infinity,
      height: 50.0,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Material(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                onPressed: getImage,
                icon: const Icon(Icons.image),
                color: Colors.lightBlueAccent,
              ),
            ),
          ),
          Material(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                onPressed: getSticker,
                icon: const Icon(Icons.face),
                color: Colors.lightBlueAccent,
              ),
            ),
          ),
          Flexible(
              child: TextField(
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15.0,
            ),
            controller: textEditingController,
            decoration: const InputDecoration.collapsed(
              hintText: "Write here ...",
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
            ),
            focusNode: focusNode,
          )),
          Material(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                onPressed: () => onSendMessage(textEditingController.text, 0),
                icon: const Icon(Icons.send),
                color: Colors.lightBlueAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onSendMessage(String contentMsg, int type) {
    // type = 0 its text msg
    // type = 1 its imageFile
    // type = 2 its sticker-emoji-gifs
    if (contentMsg != "") {
      textEditingController.clear();
      var docRef = FirebaseFirestore.instance
          .collection("messages")
          .doc(chatId)
          .collection(chatId!)
          .doc(DateTime.now().microsecondsSinceEpoch.toString());
      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(docRef, {
          "idFrom": id,
          "idTo": widget.receiverId,
          "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
          "content": contentMsg,
          "type": type,
        });
      });
      listscrollController.animateTo(0.0,
          duration: const Duration(microseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: "Empty Message, Can not be send");
    }
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? imageFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      isLoading = true;
    }
    uploadImageFile();
  }

  Future uploadImageFile() async {
    String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference storageReference =
        FirebaseStorage.instance.ref().child("Chat Images").child(fileName);

    UploadTask storageUploadTask = storageReference.putFile(imageFile!);
    TaskSnapshot storageTaskSnapshot =
        await storageUploadTask.whenComplete(() {});

    storageTaskSnapshot.ref.getDownloadURL().then(
      (downloadUrl) {
        // Handle success
        imageUrl = downloadUrl;
        setState(() {
          isLoading = false;
          onSendMessage(imageUrl!, 1);
        });
      },
      onError: (error) {
        // Handle error
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: "Error: $error");
      },
    );
  }
}
