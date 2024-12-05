import 'package:chatappbuild/auth/authservice.dart';
import 'package:chatappbuild/chatpage.dart';
import 'package:chatappbuild/chatservices/chatservices.dart';
import 'package:chatappbuild/friendrequestpage.dart';
import 'package:chatappbuild/geminipage.dart';
import 'package:chatappbuild/mydrawer.dart';
import 'package:chatappbuild/searchbar.dart';
import 'package:chatappbuild/usertile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});
  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  final chatservices chat = chatservices();
  final authservice auth = authservice();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth fauth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HOME"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.tertiary,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FriendRequestsScreen(),
                    ));
              },
              icon: Icon(Icons.notification_add)),
          SizedBox(
            width: 5,
          )
        ],
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => geminipage(),
                      ));
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.tertiary
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(
                                "https://uxwing.com/wp-content/themes/uxwing/download/brands-and-social-media/google-gemini-icon.png"),
                          ),
                          Text(
                            "Ask Something",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(child: builduserlist()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const searchbar()));
        },
        elevation: 10,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(
          Icons.group,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }

  Widget builduserlist() {
    return StreamBuilder(
      stream: chat.getuserstream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(
            "Error",
            style:
                TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Lottie.network(
                'https://lottie.host/d4ed5a5f-efd5-4af1-baab-55c29f780986/v3nwDQqvyA.json'),
          );
        }
        return FutureBuilder(
          future: _getAcceptedFriends(snapshot.data!),
          builder: (context, friendsSnapshot) {
            if (friendsSnapshot.hasError) {
              return Text(
                "Error",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary),
              );
            }
            if (friendsSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  children: [
                    Lottie.network(
                        'https://lottie.host/d4ed5a5f-efd5-4af1-baab-55c29f780986/v3nwDQqvyA.json'),
                  ],
                ),
              );
            }
            return ListView(
              children: friendsSnapshot.data!
                  .map<Widget>(
                      (userdata) => builduseritemlist(userdata, context))
                  .toList(),
            );
          },
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> _getAcceptedFriends(
      List<Map<String, dynamic>> users) async {
    List<Map<String, dynamic>> acceptedFriends = [];
    for (var user in users) {
      if (user["email"] != auth.getcurrentuser()!.email) {
        final friendRequestDoc = await _firestore
            .collection('friendRequests')
            .where('senderId', isEqualTo: auth.getcurrentuser()!.uid)
            .where('receiverId', isEqualTo: user["uid"])
            .get();
        if (friendRequestDoc.docs.isNotEmpty) {
          final friendRequestStatus = friendRequestDoc.docs[0]['status'];
          if (friendRequestStatus == 'accepted') {
            acceptedFriends.add(user);
          }
        } else {
          final friendRequestDoc = await _firestore
              .collection('friendRequests')
              .where('senderId', isEqualTo: user["uid"])
              .where('receiverId', isEqualTo: auth.getcurrentuser()!.uid)
              .get();
          if (friendRequestDoc.docs.isNotEmpty) {
            final friendRequestStatus = friendRequestDoc.docs[0]['status'];
            if (friendRequestStatus == 'accepted') {
              acceptedFriends.add(user);
            }
          }
        }
      }
    }
    return acceptedFriends;
  }

  Widget builduseritemlist(
      Map<String, dynamic> userdata, BuildContext context) {
    return UserTile(
      text: userdata["email"],
      uid: userdata["uid"],
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => chatpage(
                email: userdata["email"],
                id: userdata["uid"],
              ),
            ));
      },
    );
  }
}
