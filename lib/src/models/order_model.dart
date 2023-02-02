// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:greengrocer/src/models/cart_item_model.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderModel {
  String id;

  //no back o nome e createdAt
  @JsonKey(name: 'createdAt')
  DateTime? createDateTime;

  //nome q vem do back e due converter overdueDateTime
  @JsonKey(name: 'due')
  DateTime overdueDateTime;

  @JsonKey(defaultValue: [])
  List<CartItemModel> items;

  String status;
  String qrCodeImage;

  //nome q vem do back e due, converter copyAndPaste
  @JsonKey(name: 'copiaecola')
  String copyAndPaste;

  //verificar se o pagamento esta vencido pela data
  bool get isOverDue => overdueDateTime.isBefore(DateTime.now());

  double total;
  OrderModel({
    required this.id,
    this.createDateTime,
    required this.overdueDateTime,
    required this.items,
    required this.status,
    required this.qrCodeImage,
    required this.copyAndPaste,
    required this.total,
  });

  // referencia ao um metodo auto gerado _$OrderModelFromJson
  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  @override
  String toString() {
    return 'OrderModel(id: $id, createDateTime: $createDateTime, overdueDateTime: $overdueDateTime, items: $items, status: $status, qrCodeImage: $qrCodeImage, copyAndPaste: $copyAndPaste, total: $total)';
  }
}
