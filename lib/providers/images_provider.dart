import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

//Subir imagen a Firebase
Future<String> uploadImage(File image, String productId) async{
  final collection = 'uploads';
  await Firebase.initializeApp();
  final storage = FirebaseStorage.instance;
  var snapshot = await storage.ref()
    .child('$collection/$productId')
    .putFile(image);
  var url = await snapshot.ref.getDownloadURL();
  return url.toString();
}
