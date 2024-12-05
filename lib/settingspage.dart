import 'dart:io';

import 'package:chatappbuild/theme/themeprovider.dart';
import 'package:chatappbuild/userdetailpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class settingpage extends StatefulWidget {
  const settingpage({super.key});

  @override
  State<settingpage> createState() => _settingpageState();
}

class _settingpageState extends State<settingpage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  File? imageFile;
  String? imagePath;

  @override
  void initState() {
    super.initState();
    loadUserProfileImage();
  }

  Future<void> loadUserProfileImage() async {
    User? user = auth.currentUser; // Get the current user
    if (user != null) {
      DocumentReference userDoc = firestore.collection('Users').doc(user.uid);
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
      print("User is not authenticated");
    }
  }

  void userdetai() {
    // Navigate to the UserDetailPage
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => userdetail()),
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = auth.currentUser;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        title: const Text("SETTINGS"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.tertiary,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 5),
            padding: EdgeInsets.symmetric(vertical: 20),
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.secondary),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Space between elements
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    imageFile != null
                        ? Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context).colorScheme.secondary,
                                      Theme.of(context).colorScheme.tertiary
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight),
                                shape: BoxShape.circle),
                            child: CircleAvatar(
                              radius: 48,
                              backgroundColor: Colors.transparent,
                              backgroundImage: FileImage(imageFile!),
                            ),
                          )
                        : imagePath != null
                            ? Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                          Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          Theme.of(context).colorScheme.tertiary
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight),
                                    shape: BoxShape.circle),
                                child: CircleAvatar(
                                  radius: 48,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: NetworkImage(imagePath!),
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        Theme.of(context).colorScheme.secondary,
                                        Theme.of(context).colorScheme.tertiary
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight),
                                      shape: BoxShape.circle
                                ),
                                child: CircleAvatar(
                                  radius: 48,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: NetworkImage(
                                      'https://static.vecteezy.com/system/resources/thumbnails/020/911/740/small_2x/user-profile-icon-profile-avatar-user-icon-male-icon-face-icon-profile-icon-free-png.png'),
                                ),
                              ),
                    SizedBox(
                        width: 10), // Add some space between avatar and text
                    user != null
                        ? Text(
                            "${user.email!.split('@').first}",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary,
                                fontSize: 20),
                          )
                        : Text("No Current User Logged In"),
                  ],
                ),
                IconButton(
                  onPressed: userdetai,
                  icon: Icon(
                    Icons.edit,
                    size: 40,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(25),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Purple accent color",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
                CupertinoSwitch(
                  value: Provider.of<ThemeProvider>(context, listen: false)
                      .isDarkMode,
                  onChanged: (value) =>
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
