import 'package:get/get.dart';
import 'package:greengrocer/src/models/category_model.dart';
import 'package:greengrocer/src/models/item_model.dart';
import 'package:greengrocer/src/pages/home/repository/home_repository.dart';
import 'package:greengrocer/src/pages/home/result/home_result.dart';
import 'package:greengrocer/src/services/utils_service.dart';

int itemsPerPage = 0;

class HomeController extends GetxController {
  final homeRepository = HomeRepository();

  final utilsServices = UtilsServices();
  bool isCategoryLoading = false;
  bool isProductLoading = true;
  List<CategoryModel> allCategories = [];
  CategoryModel? currentCategory;

  //Caso seja null o retorno, e setado vasio []
  List<ItemModel> get allProducts => currentCategory?.items ?? [];

  //verifica se esta na ultima tela da paginação
  bool get isLastPage {
    if (currentCategory!.items.length < itemsPerPage) return true;
    return currentCategory!.pagination * itemsPerPage > allProducts.length;
  }

  void setLoading(bool valeu, {bool isProduct = false}) {
    //verifica se e para carregar produtos ou categorias
    if (!isProduct) {
      isCategoryLoading = valeu;
    } else {
      isProductLoading = valeu;
    }

    update();
  }

  @override
  void onInit() {
    super.onInit();
    getAllCategories();
  }

  //categoria selecionada
  void selectCategory(CategoryModel category) {
    currentCategory = category;
    update();

    //verifica se tem item na lista de produtos e apresenta conforme selecionado no menu de categorias com isso nao vai fazer novas requisições ao selecionar uma categoria
    if (currentCategory!.items.isNotEmpty) return;

    getAllProducts();
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

  //carrega mais produtos
  loadMoreProducts() {
    currentCategory!.pagination++;
    getAllProducts(canLoad: false);
  }

  Future<void> getAllProducts({bool canLoad = true}) async {
    if (canLoad) {
      setLoading(true, isProduct: true);
    }

    //Dados passado no body
    Map<String, dynamic> body = {
      'page': currentCategory!.pagination,
      'categoryId': currentCategory!.id,
      'itemsPerPage': itemsPerPage,
    };

    HomeResult<ItemModel> result = await homeRepository.getAllProducts(body);

    setLoading(false, isProduct: true);

    result.when(
      success: (data) {
        currentCategory!.items.addAll(data);
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }
}
