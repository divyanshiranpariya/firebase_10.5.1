import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase4/model/user_model.dart';
import 'package:firebase4/utils/auth_helper.dart';

class FirestoreHelper {
  FirestoreHelper._();

  static final FirestoreHelper firestoreHelper = FirestoreHelper._();
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  addAuthenticationUser({required UserModel userModel}) async {
    bool isUserExists = false;

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await db.collection("users").get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
        querySnapshot.docs;
    allDocs.forEach((doc) {
      Map<String, dynamic> dataOfData = doc.data();

      if (dataOfData['email'] == userModel.email) {
        isUserExists = true;
      }
    });

    if (isUserExists == false) {
      DocumentSnapshot<Map<String, dynamic>> qs =
          await db.collection("records").doc("users").get();
      Map<String, dynamic>? data = qs.data();

      int id = data!['id'];
      int counter = data!['counter'];
      id++;

      await db.collection("users").doc("$id").set({
        "id": userModel.id,
        "name": userModel.name,
        "email": userModel.email,
        "age": userModel.age
      });
      counter++;
      await db
          .collection("records")
          .doc("users")
          .update({"id": id, "counter": counter});
    }
  }

  //fetch user

  fetchAllUser() {
    return db.collection("users").snapshots();
  }

  deleteUser({required String docId}) async {
    await db.collection("users").doc(docId).delete();
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await db.collection("records").doc("users").get();
    int counter = userDoc.data()!['counter'];
    counter--;

    await db.collection("records").doc("users").update({"counter": counter});
  }

  //check a chatroom and store message

  sendMessage({required String msg, required String reciverEmail}) async {
    String senderEmail = AuthHelper.firebaseAuth.currentUser!.email!;
    bool isChatroomExists = false;

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await db.collection("chatrooms").get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> allChartrooms =
        querySnapshot.docs;
    String? chatroomId;

    allChartrooms.forEach((chatroom) {
      List users = chatroom.data()['users'];

      if (users.contains(reciverEmail) && users.contains(senderEmail)) {
        isChatroomExists = true;
        chatroomId = chatroom.id;
      }
    });
    if (isChatroomExists == false) {
      DocumentReference<Map<String, dynamic>> docRef =
          await db.collection("chatrooms").add({
        "users": [senderEmail, reciverEmail]
      });
      chatroomId = docRef.id;
    }

    await db
        .collection("chatrooms")
        .doc(chatroomId)
        .collection("messages")
        .add({
      "msg": msg,
      "senderEmail": senderEmail,
      "receiverEmail": reciverEmail,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  fetchAllMessages({required String receiverEmail}) async {
    String senderEmail = AuthHelper.firebaseAuth.currentUser!.email!;
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await db.collection("chatrooms").get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> allChatrooms =
        querySnapshot.docs;

    String? chatroomId;

    allChatrooms
        .forEach((QueryDocumentSnapshot<Map<String, dynamic>> chatroom) {
      List users = chatroom.data()['users'];

      if (users.contains(receiverEmail) && users.contains(senderEmail)) {
        chatroomId = chatroom.id;
      }
      ;
    });
    return db
        .collection("chatrooms")
        .doc(chatroomId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }
}
