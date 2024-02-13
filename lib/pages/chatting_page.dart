import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
      body: ChatScreen(
          receiverId: widget.receiverId, receiverAvatar: widget.receiveravatar),
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
  final FocusNode focusNode = FocusNode();
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
            // Input controllers
            createInput(),
          ],
        )
      ],
    ));
  }

  createListMessages() {
    return const Flexible(
        child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
    ));
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
                onPressed: () => print("clicked"),
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
                onPressed: () => print("clicked"),
                icon: const Icon(Icons.face),
                color: Colors.lightBlueAccent,
              ),
            ),
          ),
          Flexible(
              child: Container(
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
            ),
          )),
          Material(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                onPressed: () => print("clicked"),
                icon: const Icon(Icons.send),
                color: Colors.lightBlueAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
