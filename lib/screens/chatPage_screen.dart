import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/widgets/Conversation.dart';
import 'addUser_screen.dart';
import 'message_screen.dart';
import 'profile_screen.dart';
import 'package:whisper/widgets/bg_scaffold.dart';

int check = 0;
int check2 = 0;

class ChatUsers {
  String imageURL;
  ChatUsers({
    required this.imageURL,
  });
}

class ChatPageState {
  static List<ChatUsers> chatUsers = [
    ChatUsers(
      imageURL: "assets/images/profile1.png",
    ),
    ChatUsers(
      imageURL: "assets/images/profile2.png",
    ),
    ChatUsers(
      imageURL: "assets/images/profile3.png",
    ),
    ChatUsers(
      imageURL: "assets/images/profile4.png",
    ),
    ChatUsers(
      imageURL: "assets/images/profile5.png",
    ),
    ChatUsers(
      imageURL: "assets/images/profile6.png",
    ),
    ChatUsers(
      imageURL: "assets/images/profile7.png",
    ),
    ChatUsers(
      imageURL: "assets/images/profile8.png",
    ),
    ChatUsers(
      imageURL: "assets/images/profile9.png",
    ),
    ChatUsers(
      imageURL: "assets/images/profile10.png",
    ),
  ];
}

Future<List<Map<String, dynamic>>> fetchUsers() async {
  QuerySnapshot querySnapshot =
  await FirebaseFirestore.instance.collection('users').get();
  return querySnapshot.docs
      .map((doc) => doc.data() as Map<String, dynamic>)
      .toList();
}

class ChatPage extends StatefulWidget {
  final String email;
  final String currentuser;

  ChatPage({required this.currentuser, required this.email});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatUsers? selectedUser;

  @override
  Widget build(BuildContext context) {
    return BGScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const Text(
          'Whisper',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => profile(currentuser: widget.currentuser, email: widget.email)),
                );
              },
              child: const CircleAvatar(
                backgroundImage: NetworkImage('https://plus.unsplash.com/premium_photo-1673866484792-c5a36a6c025e?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsfGVufDB8fDB8fHww%3D%3D'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        height: 50,
        width: 80,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProfileScreen(currentuser: widget.currentuser, currentemail: widget.email)),
              );
            },
            icon: const Icon(CupertinoIcons.person_add),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 100,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No users found'));
                } else {
                  List<Map<String, dynamic>> users = snapshot.data!;
                  bool userAdded = false;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: users.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      String currentUser = users[index]['CurrentUser'] as String? ?? '';
                      if (currentUser == widget.currentuser) {
                        userAdded = true;
                        return Padding(
                          padding: EdgeInsets.fromLTRB(15, 10, 5, 0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MessageScreen(
                                    receiver: users[index]['AddedUser'] as String? ?? 'No Name',
                                    currentuser: widget.currentuser,
                                    imageurl: ChatPageState.chatUsers[index % ChatPageState.chatUsers.length].imageURL,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: AssetImage(ChatPageState.chatUsers[index % ChatPageState.chatUsers.length].imageURL),
                                ),
                                Text(users[index]['AddedUser'] as String? ?? 'No Name', style: TextStyle(fontSize: 15, color: Colors.white)),
                              ],
                            ),
                          ),
                        );
                      }
                      if (!userAdded && index == users.length - 1) {
                        return Container(
                          padding: EdgeInsets.fromLTRB(15, 10, 5, 0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(''),
                              ),
                              Text('No User Added', style: TextStyle(fontSize: 15, color: Colors.white)),
                            ],
                          ),
                        );
                      }
                      return SizedBox.shrink();
                    },
                  );
                }
              },
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  topLeft: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 65,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Search",
                          hintStyle: TextStyle(color: Colors.grey.shade600),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade600,
                            size: 20,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60),
                            borderSide: BorderSide(color: Colors.grey.shade100),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: fetchUsers(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text('No users found'));
                        } else {
                          List<Map<String, dynamic>> users = snapshot.data!;
                          bool userAdded = false;
                          return ListView.builder(
                            itemCount: users.length,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(top: 16),
                            itemBuilder: (context, index) {
                              String currentUser = users[index]['CurrentUser'] as String? ?? '';
                              String addedUser = users[index]['AddedUser'] as String? ?? 'No Name';
                              String addedEmail = users[index]['AddedEmail'] as String? ?? 'No Email';

                              if (currentUser == widget.currentuser) {
                                userAdded = true;
                                return ConversationList(
                                  name: addedUser,
                                  imageUrl: ChatPageState.chatUsers[index % ChatPageState.chatUsers.length].imageURL,
                                  email: addedEmail,
                                  currentuser: widget.currentuser,
                                );
                              }
                              if (!userAdded && index == users.length - 1) {
                                return ConversationList(
                                  name: 'No user Added',
                                  imageUrl: '',
                                  email: '',
                                  currentuser: widget.currentuser,
                                );
                              }
                              return SizedBox.shrink();
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}