import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/pages/orders/controller/all_orders_controller.dart';
import '../view/compoments/order_tile.dart';

class OrdersTab extends StatelessWidget {
  OrdersTab({Key? key}) : super(key: key);
  final allOrdersController = AllOrdersController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
        actions: [
          IconButton(
            onPressed: () {
              allOrdersController.getAllOrders();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: GetBuilder<AllOrdersController>(
        builder: (controller) {
          return RefreshIndicator(
            onRefresh: () => controller.getAllOrders(),
            child: ListView.separated(
              padding: const EdgeInsets.all(17),
              physics: const AlwaysScrollableScrollPhysics(),
              separatorBuilder: (_, index) {
                return const SizedBox(
                  height: 10,
                );
              },
              itemBuilder: (_, index) {
                return OrderTile(order: controller.allOrders[index]);
              },
              itemCount: controller.allOrders.length,
            ),
          );
        },
      ),
    );
  }
}
