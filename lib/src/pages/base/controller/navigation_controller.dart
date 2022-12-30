import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

//para facilitar o acesso ao numero das pages na tab da base_screen
abstract class NavigationTabs {
  static const int home = 0;
  static const int cart = 1;
  static const int orders = 2;
  static const int profile = 3;
}

class NavigationController extends GetxController {
  late PageController _pageController;
  late RxInt _currentIndex;

  PageController get pageController => _pageController;
  int get currentIndex => _currentIndex.value;

  @override
  void onInit() {
    super.onInit();

    //para inicializar o metodo de navegacao quando o app for carregado
    _initNavigation(
      pageController: PageController(
        initialPage: NavigationTabs.home,
      ),
      currentIndex: NavigationTabs.home,
    );
  }

  void _initNavigation({
    required PageController pageController,
    required int currentIndex,
  }) {
    _pageController = pageController;
    _currentIndex = currentIndex.obs;
  }

  //controlar navegação
  void navigatePageView(int page) {
    //verifica se a page clicada e a atual p/ nao tentar reabrir
    if (_currentIndex.value == page) return;

    _pageController.jumpToPage(page);
    _currentIndex.value = page;
  }
}
