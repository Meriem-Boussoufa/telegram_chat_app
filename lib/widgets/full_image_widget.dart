import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullPhoto extends StatelessWidget {
  final String url;
  const FullPhoto({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Full Image",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FullPhotoScreen(url: url),
    );
  }
}

class FullPhotoScreen extends StatefulWidget {
  final String url;
  const FullPhotoScreen({super.key, required this.url});

  @override
  State<FullPhotoScreen> createState() => _FullPhotoScreenState();
}

class _FullPhotoScreenState extends State<FullPhotoScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PhotoView(imageProvider: NetworkImage(widget.url));
  }
}
