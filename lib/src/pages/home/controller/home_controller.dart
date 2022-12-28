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

  //campo de pesquisa
  RxString searchTitle = ''.obs;

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

    //fica observando a variavel para veririficar seu valor
    debounce(
      searchTitle,
      (_) {
        filterByTitle();
      },
      time: const Duration(milliseconds: 600),
    );
    getAllCategories();
  }

  // buscar produtos campo de pesquisa
  void filterByTitle() {
    //apagar todas os produtos das categorias ja carregados p/ a pesquisa nao ficar separada
    for (var category in allCategories) {
      category.items.clear();
      category.pagination = 0;
    }

    //verifica se o campo de pesquisa esta vazio o foi limpo
    if (searchTitle.value.isEmpty) {
      //remove a nova categoria todos q foi criada na pesquisa
      allCategories.removeAt(0);
    } else {
      //Verifica se a categoria todos ja existe
      CategoryModel? c = allCategories.firstWhereOrNull((cat) => cat.id == '');

      if (c == null) {
        //Criar nova categoria "Todos" para receber resultado da pesquisa
        final allProductsCategory = CategoryModel(
          pagination: 0,
          items: [],
          title: 'Todos',
          id: '',
        );
        //inserir nova categoria, o 0 e a posição
        allCategories.insert(0, allProductsCategory);
      } else {
        c.items.clear();
        c.pagination = 0;
      }
    }

    //deixa a nova categoria selecionada
    currentCategory = allCategories.first;

    update();
    getAllProducts();
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

    //Verifica se foi feito uma pesquisa
    if (searchTitle.value.isNotEmpty) {
      //passa novo valor para title  q esta no body
      body['title'] = searchTitle.value;

      if (currentCategory!.id == '') {
        body.remove('categoryId');
      }
    }

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
