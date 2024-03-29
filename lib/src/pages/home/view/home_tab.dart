import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart' hide Badge;
import 'package:get/get.dart';
import 'package:greengrocer/src/config/custom_colors.dart';
import 'package:greengrocer/src/pages/base/controller/navigation_controller.dart';
import 'package:greengrocer/src/pages/cart/controller/cart_controller.dart';
import 'package:greengrocer/src/pages/commons_widgets/app_name_widget.dart';
import 'package:greengrocer/src/pages/commons_widgets/custom_shimmer.dart';
import 'package:greengrocer/src/pages/home/controller/home_controller.dart';
import 'package:greengrocer/src/pages/home/view/components/category_tile.dart';
import 'package:greengrocer/src/pages/home/view/components/item_tile.dart';
import 'package:greengrocer/src/services/utils_service.dart';

class HomeTap extends StatefulWidget {
  const HomeTap({Key? key}) : super(key: key);

  @override
  State<HomeTap> createState() => _HomeTapState();
}

class _HomeTapState extends State<HomeTap> {
  GlobalKey<CartIconKey> globalKeycartItems = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCardAnimation;
  void itemSelectedCartAnimations(GlobalKey gkImage) {
    runAddToCardAnimation(gkImage);
  }

  //controller campo de pesquisa
  final searchController = TextEditingController();

  final UtilsServices utilsServices = UtilsServices();
  final controller = Get.find<CartController>();
  final navigationController = Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
            utilsServices.showToast(message: 'Teste Toast.', isError: true);
          },
          child: const AppNameWidget(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              top: 15,
              right: 15,
            ),
            child: GetBuilder<CartController>(
              builder: (controller) {
                return GestureDetector(
                  onTap: () {
                    navigationController.navigatePageView(NavigationTabs.cart);
                  },
                  child: badges.Badge(
                    badgeStyle: badges.BadgeStyle(
                      badgeColor: CustomColors.customContrastColor,
                    ),
                    badgeContent: Text(
                      controller.cartItems.length.toString(),
                      //controller.getCartTotalItems().toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    child: AddToCartIcon(
                      key: globalKeycartItems,
                      icon: Icon(
                        Icons.shopping_cart,
                        color: CustomColors.customSwatchColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      body: AddToCartAnimation(
        gkCart: globalKeycartItems,
        previewDuration: const Duration(milliseconds: 100),
        previewCurve: Curves.ease,
        receiveCreateAddToCardAnimationMethod: (addToCardAnimationMethod) {
          runAddToCardAnimation = addToCardAnimationMethod;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            children: [
              //Campo pesquisa
              GetBuilder<HomeController>(
                builder: (controller) {
                  return TextFormField(
                    controller: searchController,
                    onChanged: ((value) {
                      controller.searchTitle.value = value;
                    }),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
                      hintText: 'Pesquisar',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: CustomColors.customContrastColor,
                        size: 25,
                      ),
                      //icon para lipar campo de pesquisa
                      suffixIcon: controller.searchTitle.value.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                searchController.clear();
                                controller.searchTitle.value = '';
                                //fechar teclado
                                FocusScope.of(context).unfocus();
                              },
                              icon: Icon(
                                Icons.close,
                                color: CustomColors.customContrastColor,
                                size: 21,
                              ),
                            )
                          : null,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          )),
                    ),
                  );
                },
              ),

              //categorias
              GetBuilder<HomeController>(
                builder: (controller) {
                  return SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, index) {
                        // _ significa contexto
                        return CategoryTile(
                          onPressed: () {
                            controller.selectCategory(
                                controller.allCategories[index]);
                          },
                          category: controller.allCategories[index].title,
                          isSelected: controller.allCategories[index] ==
                              controller.currentCategory,
                        );
                      },
                      separatorBuilder: (_, index) => const SizedBox(
                        width: 10,
                      ),
                      itemCount: controller.allCategories.length,
                    ),
                  );
                },
              ),

              //Grid
              GetBuilder<HomeController>(
                builder: (controller) {
                  return Expanded(
                    child: !controller.isProductLoading
                        //o visibility vai mostrar os itens, se for feito uma pesquisa vai mostrar uma mensagem nas demais categorias
                        ? Visibility(
                            visible: (controller.currentCategory?.items ?? [])
                                .isNotEmpty,
                            //caso seja feito pesquisa sera mostrado a mensagem
                            replacement: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  color: CustomColors.customSwatchColor,
                                  size: 60,
                                ),
                                const Text(
                                    'Não há itens relacionados a sua pesquisa.')
                              ],
                            ),
                            child: GridView.builder(
                              padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 9 / 11.5,
                              ),
                              itemCount: controller.allProducts.length,
                              itemBuilder: (_, index) {
                                if (((index + 1) ==
                                        controller.allProducts.length) &&
                                    !controller.isLastPage) {
                                  controller.loadMoreProducts();
                                }

                                return ItemTile(
                                  item: controller.allProducts[index],
                                  cartAnimationMethod:
                                      itemSelectedCartAnimations,
                                );
                              },
                            ),
                          )
                        : GridView.count(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                            physics: const BouncingScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 9 / 11.5,
                            children: List.generate(
                              10,
                              (index) => CustomShimmer(
                                height: double.infinity,
                                width: double.infinity,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
