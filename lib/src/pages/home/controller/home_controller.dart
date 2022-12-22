import 'package:get/get.dart';
import 'package:greengrocer/src/models/category_model.dart';
import 'package:greengrocer/src/pages/home/repository/home_repository.dart';
import 'package:greengrocer/src/pages/home/result/home_result.dart';
import 'package:greengrocer/src/services/utils_service.dart';

class HomeController extends GetxController {
  final homeRepository = HomeRepository();

  final utilsServices = UtilsServices();
  bool isLoading = false;
  List<CategoryModel> allCategories = [];
  CategoryModel? currentCategory;

  void setLoading(bool valeu) {
    isLoading = valeu;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getAllCategories();
  }

  void selectCategory(CategoryModel category) {
    currentCategory = category;
    update();
  }

  Future<void> getAllCategories() async {
    setLoading(true);

    HomeResult<CategoryModel> homeResult =
        await homeRepository.getAllCategories();

    setLoading(false);

    homeResult.when(
      success: (data) {
        allCategories.assignAll(data);

        //Caso back retorne uma lista vazia
        if (allCategories.isEmpty) return;

        //Pegar o primeiro item da lista
        selectCategory(allCategories.first);
      },
      error: (message) {
        utilsServices.showToast(
          message: 'message',
          isError: true,
        );
      },
    );
  }
}
