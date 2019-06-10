import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CrudMedthods {
  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addData(newContact) async {
    if (isLoggedIn()) {
      Firestore.instance.collection('usuario').add(newContact).catchError((e) {
        print(e);
      });
    } else {
      print('You need to be logged in');
    }
  }
}
