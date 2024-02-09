import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Telegram Clone',
        theme: ThemeData(
          primaryColor: Colors.lightBlueAccent,
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Coding Cafe',
              style: TextStyle(
                fontSize: 26.0,
                color: Colors.white,
              ),
            ),
          ),
          body: const Center(
            child: Text(
              'Welcome to Telegram Clone App',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        ));
  }
}
