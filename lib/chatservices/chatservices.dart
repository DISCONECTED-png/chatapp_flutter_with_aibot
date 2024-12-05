import 'package:chatappbuild/chatservices/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class chatservices {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Stream<List<Map<String, dynamic>>> getuserstream() {
    return firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  Future<void> sendmessage(String recieverid, message) async {
    final String currentuserid = auth.currentUser!.uid;
    final String currentuseremail = auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newmessage = Message(
        senderid: currentuserid,
        senderemail: currentuseremail,
        recieverid: recieverid,
        message: message,
        timestamp: timestamp);

    List<String> ids = [currentuserid, recieverid];
    ids.sort();
    String chatroomid = ids.join("_");

    await firestore
        .collection("chat_rooms")
        .doc(chatroomid)
        .collection("messages")
        .add(newmessage.tomap());
  }

  Stream<QuerySnapshot> getmessages(String userid, otheruserid) {
    List<String> ids = [userid, otheruserid];
    ids.sort();
    String chatroomid = ids.join("_");

    return firestore
        .collection("chat_rooms")
        .doc(chatroomid)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
