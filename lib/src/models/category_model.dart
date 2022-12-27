// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:greengrocer/src/models/item_model.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  String title;
  String id;

// MOntagem da lista de produtos pesquisados pela lista de categorias
  @JsonKey(defaultValue: [])
  List<ItemModel> items;

  //Utilizado na paginação dos produtos
  @JsonKey(defaultValue: 0)
  int pagination;

  CategoryModel({
    required this.pagination,
    required this.items,
    required this.title,
    required this.id,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  @override
  String toString() {
    return 'CategoryModel(title: $title, id: $id, items: $items, pagination: $pagination)';
  }
}
