import 'package:flutter/material.dart';
import 'package:greengrocer/src/config/app_data.dart' as appData;

import 'compoments/order_tile.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(17),
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (_, index) {
          return const SizedBox(
            height: 10,
          );
        },
        itemBuilder: (_, index) {
          return OrderTile(order: appData.orders[index]);
        },
        itemCount: appData.orders.length,
      ),
    );
  }
}
