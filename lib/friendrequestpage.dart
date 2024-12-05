import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendRequestsScreen extends StatefulWidget {
  @override
  State<FriendRequestsScreen> createState() => _FriendRequestsScreenState();
}

class _FriendRequestsScreenState extends State<FriendRequestsScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'FRIEND REQUESTS',
        style: TextStyle(
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),backgroundColor: Colors.transparent,
      foregroundColor: Theme.of(context).colorScheme.tertiary,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('friendRequests')
            .where('receiverId', isEqualTo: auth.currentUser!.uid)
            .where('status', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final requests = snapshot.data!.docs;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(request['senderId'])
                    .get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return ListTile(
                      title: Text('Loading...'),
                    );
                  }

                  final user = userSnapshot.data!;
                  final email =
                      user['email']; // Get the email from the user document

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      tileColor: Theme.of(context).colorScheme.secondary,
                      title: Text(
                        'Friend request from $email',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ), // Display email
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.check,
                              color:
                                  Theme.of(context).colorScheme.tertiary,
                            ),
                            onPressed: () {
                              acceptFriendRequest(
                                  request.id, request['senderId']);
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color:
                                  Theme.of(context).colorScheme.tertiary,
                            ),
                            onPressed: () {
                              rejectFriendRequest(request.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void acceptFriendRequest(String requestId, String senderId) async {
    // Update the friend request status and add the sender to the friends list
    await FirebaseFirestore.instance
        .collection('friendRequests')
        .doc(requestId)
        .update({
      'status': 'accepted',
    });
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.uid)
        .update({
      'friends': FieldValue.arrayUnion([senderId]),
    });
  }

  void rejectFriendRequest(String requestId) async {
    // Update the friend request status to rejected
    await FirebaseFirestore.instance
        .collection('friendRequests')
        .doc(requestId)
        .update({
      'status': 'rejected',
    });
  }
}
