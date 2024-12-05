import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class searchbar extends StatefulWidget {
  const searchbar({super.key});

  @override
  State<searchbar> createState() => _searchbarState();
}

class _searchbarState extends State<searchbar> {
  final TextEditingController search = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> allUsers = [];
  List<Map<String, dynamic>> filteredUsers = [];
  QuerySnapshot<Map<String, dynamic>>? querySnapshot;
  bool loading = false;

  void sendFriendRequest (String receiverId) async {
    final senderId = auth.currentUser!.uid; // Replace with actual sender ID
    final requestId = FirebaseFirestore.instance.collection('friendRequests').doc().id;
    await FirebaseFirestore.instance
        .collection('friendRequests')
        .doc(requestId)
        .set({
      'senderId': senderId,
      'receiverId': receiverId,
      'status': 'pending',
    });
    // Optionally, show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Friend request sent!')),
    );
  }
  void initState() {
    super.initState();
    fetchAllUsers();
  }

  Future<void> fetchAllUsers() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querysnap =
          await firestore.collection('Users').get();
      setState(() {
        allUsers =
            querysnap.docs.map((doc) => doc.data()).toList(); // Store all users
        filteredUsers = allUsers; // Initially, filtered users are all users
        loading = false; // Set loading to false after fetching
      });
    } catch (e) {
      setState(() {
        loading = false; // Set loading to false in case of error
      });
    }
  }

  void filterUsers(String query) {
    final String stringsearch = query.trim().toLowerCase();
    if (stringsearch.isNotEmpty) {
      setState(() {
        filteredUsers = allUsers.where((user) {
          return user['email'].toString().toLowerCase().contains(stringsearch);
        }).toList();
      });
    } else {
      setState(() {
        filteredUsers = allUsers; // Reset to all users if search is empty
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SEARCH USERS"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.tertiary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: search,
              onChanged: filterUsers, // Call filterUsers on text change
              decoration: InputDecoration(
                labelText: "Search by name",
                labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  color: Theme.of(context).colorScheme.inversePrimary,
                  onPressed: () => filterUsers(
                      search.text), // Optional: filter on button press
                ),
              ),
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
          ),
          loading
              ? const Center(
                  child:
                      CircularProgressIndicator()) // Center the loading indicator
              : Expanded(
                  child: filteredUsers.isNotEmpty
                      ? ListView.builder(
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final Map<String, dynamic> user =
                                filteredUsers[index];
                            String mail = user['email'];
                            String local = mail.split('@').first;
                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: ListTile(
                                  tileColor:
                                      Theme.of(context).colorScheme.secondary,
                                  title: Text(
                                    local,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                    ),
                                  ),
                                  subtitle: Text(
                                    user['email'],
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  trailing: IconButton(
                                      onPressed: () {sendFriendRequest(user['uid']);},
                                      color: Theme.of(context).colorScheme.inversePrimary,
                                      icon: Icon(
                                        Icons.add,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                      ))),
                            );
                          },
                        )
                      : Center(child: Text('No users found',style: TextStyle(color: Theme.of(context).colorScheme.tertiary,fontSize: 20),)),
                ),
        ],
      ),
    );
  }
}
