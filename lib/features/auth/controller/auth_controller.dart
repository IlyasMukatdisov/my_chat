import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/features/auth/repository/auth_repository.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository);
});

class AuthController {
  final AuthRepository authRepository;

  AuthController({required this.authRepository});

  void signInWithPhone({
    required BuildContext context,
    required String phoneNumber,
  }) {
    authRepository.signInWithPhone(
      context: context,
      phoneNumber: phoneNumber,
    );
  }
}