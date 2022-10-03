import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/features/auth/repository/auth_repository.dart';
import 'package:my_chat/models/user_model.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userDataAuthProvider = FutureProvider(
  (ref) {
    final authController = ref.watch(authControllerProvider);
    return authController.getCurrentUserData();
  },
);

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;

  AuthController({required this.authRepository, required this.ref});

  void signInWithPhone({
    required BuildContext context,
    required String phoneNumber,
  }) {
    authRepository.signInWithPhone(
      context: context,
      phoneNumber: phoneNumber,
    );
  }

  void verifyOTP(
      {required BuildContext context,
      required String verificationId,
      required String userOTP,
      required VoidCallback onSuccess}) {
    authRepository.verifyOTP(
        context: context,
        verificationId: verificationId,
        userOTP: userOTP,
        onSuccess: onSuccess);
  }

  void saveUserDataToFirebase(
      {required String name,
      required File? profilePic,
      required BuildContext context,
      required VoidCallback onSuccess}) {
    authRepository.saveUserDataToFirebase(
        name: name,
        profilePic: profilePic,
        ref: ref,
        context: context,
        onSuccess: onSuccess);
  }

  Future<UserModel?> getCurrentUserData() async {
    return await authRepository.getCurrentUserData();
  }

  Stream<UserModel> userData(String userId) {
    return authRepository.userData(userId);
  }
}
