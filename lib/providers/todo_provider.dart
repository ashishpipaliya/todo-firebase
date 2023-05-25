import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ToDoProvider extends ChangeNotifier {
  List<QueryDocumentSnapshot<Object?>>? data;

  DateTime? date;

  void setDate(DateTime? selectedDate) {
    date = selectedDate;
    notifyListeners();
  }

  Future<void> readNote() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      CollectionReference colRef = FirebaseFirestore.instance.collection(user.uid);
      colRef.orderBy('created_at', descending: true).snapshots().listen((snapshots) {
        data = snapshots.docs;
        data?.reversed.toList();
        notifyListeners();
      });
    }
  }
}
