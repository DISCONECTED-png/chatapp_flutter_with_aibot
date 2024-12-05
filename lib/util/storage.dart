import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage storage = FirebaseStorage.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

class storedata{
  Future<String> uploadimage (String childname,Uint8List file) async{
    Reference ref= storage.ref().child(childname);
    UploadTask uploadtask= ref.putData(file);
    TaskSnapshot snapshot = await uploadtask;
    String downloadurl = await snapshot.ref.getDownloadURL();
    return downloadurl;
  }
  
}