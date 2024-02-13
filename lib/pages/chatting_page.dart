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
    );
  }
}
