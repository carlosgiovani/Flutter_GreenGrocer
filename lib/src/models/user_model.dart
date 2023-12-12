import 'package:json_annotation/json_annotation.dart';

// user_model e o nome do arquivo
part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  // atribui o fullname a name evitando erro ao colocar name ao inves de fullname
  // seria como se fosse um alias
  @JsonKey(name: 'fullname')
  String? name;
  String? email;
  String? phone;
  String? cpf;
  String? password;
  String? id;
  String? token;

  UserModel({
    this.name,
    this.email,
    this.phone,
    this.cpf,
    this.password,
    this.id,
    this.token,
  });

// Recebe um map do usuario e retorna um objeto
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  // Recebe um objeto e retorna um Map do usuario novo cadastro
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

// roda o build_runner para gerar o tojson e o fromjson que vai criar o arquivo
// user_model.g.dart
// no terminal rodar o comando: flutter pub run build_runner build
// Ctrl + ponto final na class UserModel abre opções para criar toString, 
// construtor e etc