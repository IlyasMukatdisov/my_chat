import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_chat/common/utils/utils.dart';
import 'package:my_chat/features/auth/screens/otp_screen.dart';
import 'package:my_chat/generated/l10n.dart';

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({required this.auth, required this.firestore});

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
          throw Exception(e.message);
        },
        codeSent: (String verificationId, int? forceResendingToken) async {
          Navigator.pushNamed(context, OtpScreen.routeName, arguments: verificationId);
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
      result;
    } on FirebaseAuthException catch (e) {
      showSnackBar(
          context: context,
          text: "${AppLocalizations.of(context).login_error}${e.message}");
    }
  }
}
