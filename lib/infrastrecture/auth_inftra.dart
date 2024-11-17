import 'dart:developer';
import 'package:app/domain/assetModel.dart';
import 'package:app/domain/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

class AuthService {
  final auth = FirebaseAuth.instance;
  final store = FirebaseFirestore.instance;

  User? get currentUser => auth.currentUser;

  Stream<User?> get userStatus {
    return auth.authStateChanges();
  }

  Future<String> sigin(String email, String password) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        return 'success ${credential.user!.uid}';
      } else {
        return 'something error';
      }
    } on FirebaseAuthException catch (e) {
      log('error ${e.message.toString()}');
      return e.code;
    }
  }

  Future<String> signOut() async {
    try {
      await auth.signOut();
      return 'success';
    } on FirebaseAuthException catch (e) {
      log('error ${e.message}');
      return e.code;
    }
  }

  Future<User?> googleSignin() async {
    final googleSignIn = await GoogleSignIn().signIn();
    final authentication = await googleSignIn?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: authentication?.accessToken,
      idToken: authentication?.idToken,
    );
    final success = await auth.signInWithCredential(credential);
    return success.user;
  }

  Future<void> addStaff(UserModel user) async {
    final dates = DateTime.now();
    final date = DateFormat.yMMMMd('en_US').add_jms().format(dates);
    final docRef = store.collection('Staff').doc();
    await docRef.set({
      'name': user.name,
      'email': user.email,
      'mobile': user.number,
      'department': user.department,
      'joinDate': date,
      'assigned': false,
      'id': docRef.id,
    });
  }

  Future<void> updateStaff(UserModel user, String? id) async {
    try {
      await store.collection('Staff').doc(id).update({
        'name': user.name,
        'email': user.email,
        'department': user.department,
        'mobile': user.number,
      });

      final assetAssignDocs = await store
          .collection('AssetAssign')
          .where('staffId', isEqualTo: id)
          .get();

      for (var doc in assetAssignDocs.docs) {
        await doc.reference.update({'staffName': user.name});
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> addAsset(Assetmodel asset) async {
    final docReg = store.collection('Asset').doc();
    await docReg.set({
      'name': asset.name,
      'serialNumber': asset.serialNumber,
      'category': asset.category,
      'purchaseDate': asset.purchaseDate,
      'status': asset.status,
      'assigned': false,
      'id': docReg.id,
    });
  }

  Future<void> updateAsset(Assetmodel asset, String? id) async {
    await store.collection('Asset').doc(id).update({
      'name': asset.name,
      'serialNumber': asset.serialNumber,
      'category': asset.category,
      'purchaseDate': asset.purchaseDate,
      'id': id,
    });
    final assetAssignDocs = await store
        .collection('AssetAssign')
        .where('assetId', isEqualTo: id)
        .get();

    for (var doc in assetAssignDocs.docs) {
      await doc.reference.update({'assetName': asset.name});
    }
  }

  Future<void> assignAsset({
    required String? staff,
    required String? asset,
    String? assetH,
    String? staffH,
  }) async {
    try {
      final dates = DateTime.now();
      final date = DateFormat.yMMMMd('en_US').add_jms().format(dates);

      ;
      await FirebaseFirestore.instance
          .collection('AssetAssign')
          .doc(asset)
          .set({
        'assetId': asset,
        'staffId': staff,
        'staffName': staffH,
        'assetName': assetH,
        'assignedDate': date,
        'assignId': store.collection('AssetAssign').doc().id,
      });
      await store.collection('Asset').doc(asset).update({
        'status': 'Assigned',
        'assigned': true,
      });

      await store.collection('Staff').doc(staff).update({
        'assigned': true,
      });

      await store.collection('Asset').doc(asset).update({
        'status': 'Assigned',
        'assigned': true,
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> returnAsset(
      {required String? condititon,
      String? feedback,
      String? asset,
      String? staff,
      String? staffId}) async {
    try {
      final dates = DateTime.now();
      final date = DateFormat.yMMMMd('en_US').add_jms().format(dates);
      await FirebaseFirestore.instance
          .collection('ReturnAsset')
          .doc(staff)
          .set({
        'ReturnDate': date,
        'condition': condititon,
        'feedback': feedback,
        'assetId': asset,
        'staffId': staffId,
      });
      await store.collection('Asset').doc(asset).update({
        'status': 'Available',
        'assigned': false,
      });
      await store.collection('Staff').doc(staff).update({
        'assigned': false,
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<UserModel?> getStaff() async {
    final result = await store.collection('Staff').doc().get();
    return UserModel.fromfirestore(result);
  }
}
