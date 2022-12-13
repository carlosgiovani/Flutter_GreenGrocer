import 'package:get/get.dart';
import 'package:greengrocer/src/constants/storage_keys.dart';
import 'package:greengrocer/src/models/user_model.dart';
import 'package:greengrocer/src/pages/auth/respository/auth_respository.dart';
import 'package:greengrocer/src/pages/auth/result/auth_result.dart';
import 'package:greengrocer/src/pages_routes/app_pages.dart';
import 'package:greengrocer/src/services/utils_service.dart';

class AuthController extends GetxController {
  RxBool isLoding = false.obs;

  final authRepository = AuthRepository();
  final utilsServices = UtilsServices();

  UserModel user = UserModel();

  Future<void> validateToken() async {
    //Recupera o token que foi salvo localmente
    String? token = await utilsServices.getLocalData(key: StorageKeys.token);

    if (token == null) {
      Get.offAllNamed(PagesRoutes.signInRoute);
      return;
    }

    AuthResult result = await authRepository.validateToken(token);
    result.when(
      success: (user) {
        this.user = user;
        saveTokenAndProceedToBase();
      },
      error: (message) {},
    );
  }

  void saveTokenAndProceedToBase() {
    //salvar o token
    utilsServices.saveLocalData(key: StorageKeys.token, data: user.token!);

    //Ir para tela base
    Get.offAllNamed(PagesRoutes.baseRoute);
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    isLoding.value = true;

    AuthResult result =
        await authRepository.signIn(email: email, password: password);

    isLoding.value = false;

    result.when(
      success: (user) {
        this.user = user;
        Get.offAllNamed(PagesRoutes.baseRoute);
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }

  Future<void> signOut() async {
    //zerar o user
    user = UserModel();

    //Remover o token localmente
    await utilsServices.removeLocalData(key: StorageKeys.token);

    //Ir para tela de login
    Get.offAllNamed(PagesRoutes.signInRoute);
  }
}
