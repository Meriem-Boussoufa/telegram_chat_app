import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telegram_chat/widgets/progress_widget.dart';

import '../widgets/full_image_widget.dart';

class Chat extends StatelessWidget {
  final String receiverId;
  final String receiveravatar;
  final String receiverName;
  const Chat(
      {super.key,
      required this.receiverId,
      required this.receiveravatar,
      required this.receiverName});

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
              backgroundImage: CachedNetworkImageProvider(receiveravatar),
            ),
          )
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          receiverName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child:
            ChatScreen(receiverId: receiverId, receiverAvatar: receiveravatar),
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

  // ignore: prefer_typing_uninitialized_variables
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
    id = preferences!.getString("id");

    var receiverId = widget.receiverId;

    if (id.hashCode <= receiverId.hashCode) {
      chatId = '$id-$receiverId';
    } else {
      chatId = '$receiverId-$id';
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
              createListMessages(),
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
                onPressed: () => onSendMessage("mim1", 2),
                child: Image.asset(
                  'assets/images/stickers/mim1.gif',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )),
            ElevatedButton(
                onPressed: () => onSendMessage("mim2", 2),
                child: Image.asset(
                  'assets/images/stickers/mim2.gif',
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
          ],
        ),
        // ** Second Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () => onSendMessage("mim4", 2),
                child: Image.asset(
                  'assets/images/stickers/mim4.gif',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )),
            ElevatedButton(
                onPressed: () => onSendMessage("mim5", 2),
                child: Image.asset(
                  'assets/images/stickers/mim5.gif',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )),
            ElevatedButton(
                onPressed: () => onSendMessage("mim6", 2),
                child: Image.asset(
                  'assets/images/stickers/mim6.gif',
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
                onPressed: () => onSendMessage("mim7", 2),
                child: Image.asset(
                  'assets/images/stickers/mim7.gif',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )),
            ElevatedButton(
                onPressed: () => onSendMessage("mim8", 2),
                child: Image.asset(
                  'assets/images/stickers/mim8.gif',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )),
            ElevatedButton(
                onPressed: () => onSendMessage("mim9", 2),
                child: Image.asset(
                  'assets/images/stickers/mim9.gif',
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
          : StreamBuilder<QuerySnapshot>(
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
                  log('The snapshot has Data');
                  listMessages = snapshot.data!.docs;
                  log(listMessages.toString());
                  return ListView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemCount: snapshot.data!.docs.length,
                    reverse: true,
                    controller: listscrollController,
                    itemBuilder: (context, index) =>
                        createItem(index, snapshot.data!.docs[index]),
                  );
                }
              },
            ),
    );
  }

  bool isLastMsgRight(int index) {
    if ((index > 0 &&
            listMessages != null &&
            listMessages[index - 1]["idFrom"] != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMsgLeft(int index) {
    if ((index > 0 &&
            listMessages != null &&
            listMessages[index - 1]["idFrom"] == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Widget senderItem(int index, DocumentSnapshot document) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      document["type"] == 0
          // ** Text Msg
          ? Container(
              padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              width: 200.0,
              decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(8.0)),
              margin: EdgeInsets.only(
                  bottom: isLastMsgRight(index) ? 20.0 : 10.0, right: 10.0),
              child: Text(
                document["content"],
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          : document["type"] == 1
              // ** Image Msg
              ? Container(
                  margin: EdgeInsets.only(
                      bottom: isLastMsgRight(index) ? 20.0 : 10.0, right: 10.0),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    FullPhoto(url: document["content"])));
                      },
                      child: Material(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            width: 200.0,
                            height: 200.0,
                            padding: const EdgeInsets.all(70.0),
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                            child: const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.lightBlueAccent),
                            ),
                          ),
                          errorWidget: (context, url, error) => Material(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Image.asset(
                              'assets/images/not_found.jpeg',
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          imageUrl: document["content"],
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                      )),
                )
              // ** Sticker .gif Msg
              : Container(
                  margin: EdgeInsets.only(
                      bottom: isLastMsgRight(index) ? 20.0 : 10.0, right: 10.0),
                  child: Image.asset(
                    'assets/images/stickers/${document['content']}.gif',
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.cover,
                  ),
                ),
    ]);
  }

  Widget receiverItem(int index, DocumentSnapshot document) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              isLastMsgLeft(index)
                  ? Material(
                      // ** Display receiver Profile Image
                      borderRadius: const BorderRadius.all(
                        Radius.circular(18.0),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          width: 35.0,
                          height: 35.0,
                          padding: const EdgeInsets.all(70.0),
                          child: const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.lightBlueAccent),
                          ),
                        ),
                        imageUrl: widget.receiverAvatar,
                        width: 35.0,
                        height: 35.0,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(width: 35.0),
              // ** Display Messages
              // ** Text Msg
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                document["type"] == 0
                    ? Container(
                        padding:
                            const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: 200.0,
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0)),
                        margin: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          document["content"],
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w400),
                        ),
                      )
                    : document["type"] == 1
                        // ** Image Msg
                        ? Container(
                            margin: const EdgeInsets.only(left: 10.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FullPhoto(
                                              url: document["content"])));
                                },
                                child: Material(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                      width: 200.0,
                                      height: 200.0,
                                      padding: const EdgeInsets.all(70.0),
                                      decoration: const BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                      ),
                                      child: const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.lightBlueAccent),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Material(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                      child: Image.asset(
                                        '',
                                        width: 200.0,
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    imageUrl: document["content"],
                                    width: 200.0,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                          )
                        // ** Sticker .gif Msg
                        : Container(
                            margin: EdgeInsets.only(
                                bottom: isLastMsgRight(index) ? 20.0 : 10.0,
                                right: 10.0),
                            child: Image.asset(
                              'assets/images/stickers/${document['content']}.gif',
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                            ),
                          ),
              ]),
            ],
          ),
          // ** Msg time
          // isLastMsgLeft(index)
          //     ? Container(
          //         margin:
          //             const EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5),
          //         child: Text(
          //           DateFormat("dd MMMM, yyyy - hh:mm:aa ").format(
          //               DateTime.fromMicrosecondsSinceEpoch(
          //                   int.parse(document["timestamp"]))),
          //           style: const TextStyle(
          //               color: Colors.grey,
          //               fontSize: 12.0,
          //               fontStyle: FontStyle.italic),
          //         ),
          //       )
          //     : Container()
        ],
      ),
    );
  }

  Widget createItem(int index, DocumentSnapshot document) {
    log("ID of the Login User : $id");
    log(document["idFrom"]);
    log(document["idTo"]);
    if (document["idFrom"] == id) {
      log("ENTER THE RIGHT SIDE OF MESSAGES");
      return senderItem(index, document);
    } else {
      log("ENTER THE LEFT SIDE OF MESSAGES");
      if (document["idTo"] == id) {
        log("Enter the Left Message Side of Messages");
        return receiverItem(index, document);
      } else {
        return Container();
      }
    }
  }

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
    File? image;
    ImagePicker imagePicker = ImagePicker();
    XFile? imageFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      isLoading = true;
      image = File(imageFile.path);
    }
    uploadImageFile(image!);
  }

  Future uploadImageFile(File image) async {
    String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    Reference storageReference =
        FirebaseStorage.instance.ref().child("Chat Images").child(fileName);

    UploadTask storageUploadTask = storageReference.putFile(image);
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
