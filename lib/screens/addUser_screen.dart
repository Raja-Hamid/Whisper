import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/screens/chatPage_screen.dart';
import 'package:whisper/widgets/text_field.dart';

class AddUserScreen extends StatefulWidget {
  final String currentUser;
  final String currentEmail;
  const AddUserScreen({
    Key? key,
    required this.currentUser,
    required this.currentEmail,
  }) : super(key: key);

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final emailController = TextEditingController();
  final _formAddKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Profile',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formAddKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                const CircleAvatar(
                  radius: 130,
                  backgroundImage: AssetImage('assets/images/icon.png'),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Whisper a friend',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: CustomTextField(
                    label: 'Email',
                    hintText: 'Enter Email',
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Email';
                      }
                      return null;
                    },
                    controller: emailController,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    if (_formAddKey.currentState!.validate()) {
                      String email = emailController.text;

                      Map<String, String> adduser = {
                        'CurrentUser': widget.currentUser,
                        'AddedEmail': email,
                      };

                      await FirebaseFirestore.instance
                          .collection('added_users')
                          .add(adduser);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            currentUser: widget.currentUser,
                            email: email,
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 65, vertical: 10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
