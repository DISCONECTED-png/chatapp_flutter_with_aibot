import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserTile extends StatefulWidget {
  final String text; // Display name or email
  final String uid; // User ID
  final void Function()? onTap; // Callback for tap events

  const UserTile({
    Key? key,
    required this.text,
    required this.onTap,
    required this.uid,
  }) : super(key: key);

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firebase = FirebaseFirestore.instance;
  String? imagePath; // To store the image URL

  @override
  void initState() {
    super.initState();
    loadUserProfileImage(); // Load the user profile image on initialization
  }

  Future<void> loadUserProfileImage() async {
    User? user = auth.currentUser; // Get the current user
    if (user != null) {
      DocumentReference userDoc = firebase.collection('Users').doc(widget.uid);
      DocumentSnapshot snapshot =
          await userDoc.get(); // Fetch the user document
      if (snapshot.exists) {
        setState(() {
          // Get the data from the snapshot
          final data = snapshot.data() as Map<String, dynamic>?; // Cast to Map

          // Check if data is not null and the 'photourl' field exists
          if (data != null && data['photourl'] != null) {
            imagePath = data['photourl']; // Set the image path
          } else {
            imagePath = null; // Handle case where 'photourl' does not exist
            print("Field 'photourl' does not exist in the document.");
          }
        });
      } else {
        print("Document does not exist");
      }
    } else {
      print("User  is not authenticated");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap, 
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12), 
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Display the user's profile image or a placeholder
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
          Theme.of(context).colorScheme.secondary,
          Theme.of(context).colorScheme.tertiary,
          
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight),
        shape: BoxShape.circle
              ),
              child: CircleAvatar(
                radius: 30,      
                backgroundColor: Colors.transparent,
                backgroundImage:
                    imagePath != null ? NetworkImage(imagePath!) : null,
                child: imagePath == null
                    ? Icon(Icons.person,
                        color: Theme.of(context).colorScheme.inversePrimary,
                        size: 30)
                    : null,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                widget.text.split('@').first, 
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold, 
                ),
              ),
            ),
            Icon(Icons.chevron_right,
                color: Theme.of(context).colorScheme.tertiary),
          ],
        ),
      ),
    );
  }
}
