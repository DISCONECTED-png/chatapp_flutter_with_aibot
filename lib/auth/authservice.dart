import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class authservice{
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? getcurrentuser(){
    return auth.currentUser;
  }
//sign in
  Future<UserCredential> signinwithemailandpassword(String email,password) async{
    try{
      UserCredential userCredential=await auth.signInWithEmailAndPassword(email: email, password: password);

      firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email':email
        },
        SetOptions(merge: true)
      );
      return userCredential;
    }on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }
//sign out
  Future<void>signout() async{
    await auth.signOut();
  }

//sign up
  Future<UserCredential> signupwithemailandpassword(String email,password) async{
    try{
      UserCredential userCredential=await auth.createUserWithEmailAndPassword(email: email, password: password);

      firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email':email,
        },
        SetOptions(merge: true)
      );
      return userCredential;
    }on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }
}
