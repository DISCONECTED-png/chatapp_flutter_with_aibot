import 'package:chatappbuild/auth/loginorregister.dart';
import 'package:chatappbuild/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class authgate extends StatelessWidget {
  const authgate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return const homepage();
          }
          else{
            return const loginorregister();
          }
        },
      ),
    );
  }
}