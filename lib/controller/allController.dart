import 'package:app/domain/assetModel.dart';
import 'package:app/domain/userModel.dart';
import 'package:app/infrastrecture/auth_inftra.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class AuthNotifier extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? get currentUser => _authService.currentUser;
  Stream<User?> get userStatus => _authService.userStatus;

  bool _loading = false;
  UserModel? _userModel;

  bool get loading => _loading;
  UserModel? get userModel => _userModel;

  Future<void> addStaff({
    required UserModel user,
  }) async {
    _loading = true;
    notifyListeners();
    final success = await _authService.addStaff(user);
    _loading = false;
    notifyListeners();
    return success;
  }

  Future<String> signout() async {
    _loading = true;
    notifyListeners();
    final success = await _authService.signOut();
    _loading = false;
    notifyListeners();
    return success;
  }

  Future<void> addAsset({required Assetmodel asset}) async {
    _loading = true;
    notifyListeners();
    final success = await _authService.addAsset(asset);
    _loading = false;
    notifyListeners();
    return success;
  }

  Future<User?> googlesignin() async {
    final auth = await _authService.googleSignin();

    return auth;
  }

  Future<void> assign(
      {String? staff, String? asset, String? A, String? S}) async {
    _loading = true;
    notifyListeners();
    await _authService.assignAsset(
        asset: asset, staff: staff, assetH: A, staffH: S);
    _loading = false;
    notifyListeners();
  }

  Future<void> returnAsset(
      {String? asset,
      String? staffId,
      String? condition,
      String? date,
      String? staff,
      String? feedback}) async {
    _loading = true;
    notifyListeners();
    await _authService.returnAsset(
        asset: asset,
        staff: staff,
        condititon: condition,
        feedback: feedback,
        staffId: staffId);
    _loading = false;
    notifyListeners();
  }

  Future<void> getStaff() async {
    _loading = true;
    notifyListeners();
    final data = await _authService.getStaff();
    _userModel = data!;
    _loading = false;
    notifyListeners();
  }

  Future<void> update(UserModel user, String? id) async {
    _loading = true;
    notifyListeners();
    await _authService.updateStaff(user, id);
    _loading = false;
    notifyListeners();
  }

  Future<void> updateAsset(Assetmodel asset, String? id) async {
    _loading = true;
    notifyListeners();
    await _authService.updateAsset(asset, id);
    _loading = false;
    notifyListeners();
  }
}
