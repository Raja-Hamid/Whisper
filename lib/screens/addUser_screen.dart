import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/screens/chatPage_screen.dart';
import 'package:whisper/widgets/text_field.dart';

class AddUserScreen extends StatefulWidget {
  final String currentUser;
  final String currentEmail;
  const AddUserScreen({
    super.key,
    required this.currentUser,
    required this.currentEmail,
  });

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final textAddNameController = TextEditingController();
  final textAddEmailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    textAddNameController.dispose();
    textAddEmailController.dispose();
    super.dispose();
  }

  Future<bool> _checkIfUserExists(String email, String name) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('added_users')
        .where('AddedEmail', isEqualTo: email)
        .where('AddedUser', isEqualTo: name)
        .get();

    return querySnapshot.docs.isNotEmpty;
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
          key: _formKey,
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
                    label: 'User Name',
                    hintText: 'Enter User Name',
                    keyboardType: TextInputType.name,
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter User Name';
                      }
                      return null;
                    },
                    controller: textAddNameController,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: CustomTextField(
                    label: 'User Email',
                    hintText: 'Enter User Email',
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter User Email';
                      }
                      return null;
                    },
                    controller: textAddEmailController,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final userExists = await _checkIfUserExists(
                        textAddEmailController.text,
                        textAddNameController.text,
                      );

                      if (userExists) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('User with this email and name already exists.')),
                        );
                      } else {
                        try {
                          Map<String, String> adduser = {
                            'CurrentUser': widget.currentUser,
                            'AddedUser': textAddNameController.text,
                            'AddedEmail': textAddEmailController.text,
                          };
                          await FirebaseFirestore.instance.collection('added_users').add(adduser);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                currentUser: widget.currentUser,
                                email: widget.currentEmail,
                              ),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error adding user: $e')),
                          );
                        }
                      }
                    }
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 65, vertical: 10),
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
