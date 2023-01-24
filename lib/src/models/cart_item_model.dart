// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:greengrocer/src/models/item_model.dart';

part 'cart_item_model.g.dart';

@JsonSerializable()
class CartItemModel {
  //o back retorna product e nao item, entao e preciso indicar quem vai receber product
  @JsonKey(name: 'product')
  ItemModel item;

  String id;
  int quantity;

  CartItemModel({
    required this.id,
    required this.item,
    required this.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);

  double totalPrice() {
    return item.price * quantity;
  }

  @override
  String toString() =>
      'CartItemModel(item: $item, id: $id, quantity: $quantity)';
}
