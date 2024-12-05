import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  final String senderid;
  final String senderemail;
  final String recieverid;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderid,
    required this.senderemail,
    required this.recieverid,
    required this.message,
    required this.timestamp,
  });

  Map<String,dynamic> tomap(){
    return{
      'senderid' : senderid,
      'senderemail' : senderemail,
      'receiverid' : recieverid,
      'message' : message,
      'timestamp' : timestamp
    };
  }
}