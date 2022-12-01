import 'package:get/get.dart';
import 'package:greengrocer/src/pages/auth/respository/auth_respository.dart';

class AuthController extends GetxController {
  RxBool isLoding = false.obs;

  final authRepository = AuthRepository();

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    isLoding.value = true;

    await authRepository.signIn(email: email, password: password);

    isLoding.value = false;
  }
}
