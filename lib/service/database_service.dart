import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/service/auth_service.dart';
import 'package:todo_app/utils/utils.dart';

class DatabaseProvider extends ChangeNotifier {
  String? uid = AuthService.instance.user?.uid;

  List<QueryDocumentSnapshot<Object?>>? data;
  var lastEdit = DateFormat(AppDateFormat.fullDateTimeFormat).format(DateTime.now());

  Future<bool> addNote(String title, String description, {DateTime? date}) async {
    if (uid != null) {
      DocumentReference docRef = FirebaseFirestore.instance.collection(uid!).doc();
      await docRef.set({
        "title": title,
        "description": description,
        "lastEdit": lastEdit,
        "docId": docRef.id,
        "created_at": DateTime.now().toUtc(),
        "updated_at": DateTime.now().toUtc(),
        "time": date?.toUtc()
      });
      return true;
    } else {
      return false;
    }
  }

  readNote() async {
    CollectionReference colRef = FirebaseFirestore.instance.collection(uid!);
    colRef.snapshots().listen((snapshots) {
      data = snapshots.docs;
    });
  }

  Future deleteNote(docId) async {
    CollectionReference colRef = FirebaseFirestore.instance.collection(uid!);
    await colRef.doc(docId).delete();
  }

  Future updateNote(uid, docId, String title, String description, {DateTime? date}) async {
    CollectionReference colRef = FirebaseFirestore.instance.collection(uid);
    await colRef.doc(docId).update({
      "title": title,
      "description": description,
      "lastEdit": lastEdit,
      "updated_at": DateTime.now().toUtc(),
      "time": date?.toUtc()
    });
  }
}
