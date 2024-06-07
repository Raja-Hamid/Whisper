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

Stream<QuerySnapshot> fetchUsersStream()
{
  return FirebaseFirestore.instance.collection('added_users').snapshots();
}

class ChatPage extends StatefulWidget {
  final String email;
  final String currentUser;

  const ChatPage({super.key, required this.currentUser, required this.email});

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
                  MaterialPageRoute(builder: (context) => profile(currentuser: widget.currentUser, email: widget.email)),
                );
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/profile3.png'),
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
                MaterialPageRoute(builder: (context) => AddUserScreen(currentUser: widget.currentUser, currentEmail: widget.email)),
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
              child: StreamBuilder<QuerySnapshot>(
                stream: fetchUsersStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No users found'));
                  } else {
                    final users = snapshot.data!.docs;
                    List<Widget> userWidgets = [];
                    bool userAdded = false;

                    for (var user in users) {
                      final userData = user.data() as Map<String, dynamic>;
                      final currentUser = userData['CurrentUser'] as String?;
                      final addedUser = userData['AddedUser'] as String?;

                      if (currentUser == widget.currentUser) {
                        userAdded = true;
                        userWidgets.add(
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 5, 0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MessageScreen(
                                      receiver: addedUser ?? 'No Name',
                                      currentuser: widget.currentUser,
                                      imageurl: ChatPageState.chatUsers[users.indexOf(user) % ChatPageState.chatUsers.length].imageURL,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AssetImage(ChatPageState.chatUsers[users.indexOf(user) % ChatPageState.chatUsers.length].imageURL),
                                  ),
                                  Text(
                                    addedUser ?? 'No Name',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    }

                    if (!userAdded) {
                      userWidgets.add(
                        Container(
                          padding: const EdgeInsets.fromLTRB(15, 10, 5, 0),
                          child: const Column(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(''),
                              ),
                              Text(
                                'No User Added',
                                style: TextStyle(fontSize: 15, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: userWidgets.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return userWidgets[index];
                      },
                    );
                  }
                },
              )
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.white12.withOpacity(0.8), // Adjust opacity as needed
                  ],
                  stops: const [0,0],
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(50),
                  topLeft: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: fetchUsersStream(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final users = snapshot.data!.docs;
                            List<Widget> userWidgets = [];
                            bool userAdded = false;

                            for (var user in users) {
                              final userData = user.data() as Map<String, dynamic>;
                              final currentUser = userData['CurrentUser'] as String?;
                              final addedUser = userData['AddedUser'] as String?;

                              if (currentUser == widget.currentUser) {
                                userAdded = true;
                                userWidgets.add(
                                  ConversationList(
                                    name: addedUser ?? 'No Name',
                                    imageUrl: ChatPageState.chatUsers[users.indexOf(user) % ChatPageState.chatUsers.length].imageURL,
                                    currentUser: widget.currentUser,
                                  ),
                                );
                              }
                            }

                            if (!userAdded) {
                              userWidgets.add(
                                ConversationList(
                                  name: 'No user Added',
                                  imageUrl: ' ',
                                  currentUser: widget.currentUser,
                                ),
                              );
                            }

                            return ListView(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                              children: userWidgets,
                            );
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          }
                          return const Center(child: CircularProgressIndicator());
                        },
                      )
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