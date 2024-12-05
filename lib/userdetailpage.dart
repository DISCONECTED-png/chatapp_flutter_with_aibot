import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class userdetail extends StatefulWidget {
  const userdetail({super.key});

  @override
  State<userdetail> createState() => _userdetailState();
}

class _userdetailState extends State<userdetail> {
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
    User? user = auth.currentUser;
    if (user != null) {
      DocumentReference userDoc = firestore.collection('Users').doc(user.uid);
      DocumentSnapshot snapshot = await userDoc.get();
      if (snapshot.exists) {
        setState(() {
          final data = snapshot.data() as Map<String, dynamic>?;

          if (data != null && data['photourl'] != null) {
            imagePath = data['photourl'];
          } else {
            imagePath = null;
          }
        });
      }
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      await uploadImage(); // Await the upload to ensure it completes
    } else {
      Fluttertoast.showToast(msg: "No image selected");
    }
  }

  Future<void> uploadImage() async {
    if (imageFile != null) {
      String filename = auth.currentUser!.uid;
      try {
        Reference storageRef = storage.ref().child('profilephotos/$filename');
        UploadTask uploadTask = storageRef.putFile(imageFile!);
        TaskSnapshot snapshot = await uploadTask;
        imagePath = await snapshot.ref.getDownloadURL();
        await updateUserProfile();
      } catch (e) {
        Fluttertoast.showToast(msg: "Upload failed: ${e.toString()}");
      }
    }
  }

  Future<void> updateUserProfile() async {
    User? user = auth.currentUser;

    if (user != null) {
      DocumentReference userDoc = firestore.collection('Users').doc(user.uid);
      DocumentSnapshot docSnap = await userDoc.get();
      if (docSnap.exists) {
        await userDoc.update({'photourl': imagePath}); // Update the photo URL
        Fluttertoast.showToast(msg: "Profile Photo Updated");
      } else {
        Fluttertoast.showToast(msg: "No such document exists");
      }
      setState(() {}); // Refresh the UI
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = auth.currentUser;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.tertiary,
        backgroundColor: Colors.transparent,
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            imageFile != null
                ? Stack(children: [
                    Container(
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
                        radius: 100,
                        backgroundImage: FileImage(imageFile!),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    Positioned(
                      child: Container(
                          decoration: BoxDecoration(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              borderRadius: BorderRadius.circular(100)),
                          child: IconButton(
                            onPressed: pickImage,
                            icon: Icon(
                              Icons.edit,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 40,
                            ),
                          )),
                      bottom: 0,
                      left: 130,
                    )
                  ])
                : imagePath != null
                    ? Stack(children: [
                        Container(
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
                            radius: 100,
                            backgroundImage: NetworkImage(imagePath!),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        Positioned(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                borderRadius: BorderRadius.circular(100)),
                            child: IconButton(
                              onPressed: pickImage,
                              icon: Icon(
                                Icons.edit,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 40,
                              ),
                            ),
                          ),
                          bottom: 0,
                          left: 130,
                        )
                      ])
                    : Center(
                        child: Stack(
                          children: [
                            Container(
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
                              child: const CircleAvatar(
                                radius: 100,
                                backgroundColor: Colors.transparent,
                                backgroundImage: NetworkImage(
                                    'https://static.vecteezy.com/system/resources/thumbnails/020/911/740/small_2x/user-profile-icon-profile-avatar-user-icon-male-icon-face-icon-profile-icon-free-png.png'),
                              ),
                            ),
                            Positioned(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                    borderRadius: BorderRadius.circular(100)),
                                child: IconButton(
                                    onPressed: pickImage,
                                    icon: Icon(
                                      Icons.edit,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      size: 40,
                                    )),
                              ),
                              bottom: 0,
                              left: 130,
                            )
                          ],
                        ),
                      ),
            const SizedBox(
              height: 40,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Theme.of(context).colorScheme.secondary,
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.tertiary,
                          size: 50,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Username",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              user!.email!.split('@').first,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.edit,
                        size: 30,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Theme.of(context).colorScheme.secondary,
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.email,
                      size: 40,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          user.email!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
