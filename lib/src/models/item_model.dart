import 'package:json_annotation/json_annotation.dart';

part 'item_model.g.dart';

@JsonSerializable()
class ItemModel {
  String id;

  //nome q vem do back e title e esta sendo usado itemName, para indicar q title recebera o valor de itemName
  @JsonKey(name: 'title')
  String itemName;

  //nome q vem do back e picture e esta sendo usado imgUrl, para indicar q picture recebera o valor de imgUrl
  @JsonKey(name: 'picture')
  String imgUrl;

  String unit;
  double price;
  String description;

  ItemModel({
    this.id = '',
    required this.itemName,
    required this.imgUrl,
    required this.unit,
    required this.price,
    required this.description,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) =>
      _$ItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItemModelToJson(this);
}
