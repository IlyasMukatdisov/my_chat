import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/common/repository/common_firebase_storage_repository.dart';
import 'package:my_chat/common/utils/utils.dart';
import 'package:my_chat/features/auth/screens/otp_screen.dart';
import 'package:my_chat/generated/l10n.dart';
import 'package:my_chat/models/user_model.dart';
import 'package:my_chat/utils/app_constants.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({required this.auth, required this.firestore});

  Future<UserModel?> getCurrentUserData() async {
    var userData = await firestore
        .collection(AppConstants.usersCollection)
        .doc(auth.currentUser?.uid)
        .get();

    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  Future<UserModel?> getUserData(String uid) async {
    var userData =
        await firestore.collection(AppConstants.usersCollection).doc(uid).get();

    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  void signInWithPhone({
    required BuildContext context,
    required String phoneNumber,
  }) async {
    try {
      final result = await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          throw e;
        },
        codeSent: (String verificationId, int? forceResendingToken) async {
          Navigator.pushNamed(context, OtpScreen.routeName,
              arguments: verificationId);
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
      result;
    } on FirebaseAuthException catch (e) {
      showSnackBar(
          context: context,
          text: "${AppLocalizations.of(context).login_error}${e.message}");
    } catch (e) {
      showSnackBar(
          context: context,
          text: "${AppLocalizations.of(context).login_error}${e.toString()}");
    }
  }

  void verifyOTP(
      {required BuildContext context,
      required String verificationId,
      required String userOTP,
      required VoidCallback onSuccess}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);
      await auth.signInWithCredential(credential);
      onSuccess();
    } on FirebaseAuthException catch (e) {
      showSnackBar(
        context: context,
        text: "${AppLocalizations.of(context).login_error}${e.message}",
      );
    }
  }

  void saveUserDataToFirebase(
      {required String name,
      required File? profilePic,
      required ProviderRef ref,
      required BuildContext context,
      required VoidCallback onSuccess}) async {
    try {
      final String uid = auth.currentUser!.uid;
      String photoUrl = AppConstants.defaultProfilePic;
      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeToFirebase(
                path: '${AppConstants.profilePicFolder}/$uid',
                file: profilePic);
      }
      UserModel user = UserModel(
          name: name,
          uid: uid,
          profilePic: photoUrl,
          isOnline: true,
          phoneNumber: auth.currentUser!.phoneNumber ?? '',
          groupId: []);
      await firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .set(user.toMap());
      onSuccess();
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
  }

  Stream<UserModel> userData(String userId) {
    return firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .snapshots()
        .map(
          (event) => UserModel.fromMap(event.data()!),
        );
  }

  void setUserState(bool isOnline) async {
    await firestore
        .collection(AppConstants.usersCollection)
        .doc(auth.currentUser!.uid)
        .update(
      {
        'isOnline': isOnline,
      },
    );
  }
}
