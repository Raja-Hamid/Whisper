import 'package:flutter/material.dart';
import 'package:whisper/screens/chatPage_screen.dart';

class home extends StatefulWidget {
  final String currentUser;
  final String email;

  home({required this.currentUser, required this.email});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatPage(
        currentUser: widget.currentUser,
        email: widget.email,
      ),
    );
  }
}
