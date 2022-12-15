import 'package:get/get.dart';

String? emailValidator(String? email) {
  if (email == null || email.isEmpty) {
    return 'Digite seu email.';
  }
  if (!email.isEmail) return 'Digite um email válido.';

  return null;
}

String? passwordValidator(password) {
  if (password == null || password.isEmpty) {
    return 'Digite sua senha.';
  }
  if (password.length < 7) {
    return 'Senha deve ter pelo menos 7 caracteres.';
  }
  return null;
}

String? nameValidator(String? name) {
  if (name == null || name.isEmpty) {
    return 'Digite seu nome.';
  }

  //verifica se tem espaço no nome para identificar se e um nome composto
  final names = name.split(' ');

  if (names.length == 1) {
    return 'Digite seu nome completo.';
  }
  return null;
}

String? phoneValidator(String? phone) {
  if (phone == null || phone.isEmpty) {
    return 'Digite seu telefone.';
  }
  // isPhoneNumber validacao do GETX
  if (phone.length < 14 || !phone.isPhoneNumber) {
    return 'Digite um número válido.';
  }
  return null;
}

String? cpfValidator(String? cpf) {
  if (cpf == null || cpf.isEmpty) {
    return 'Digite seu CPF.';
  }

  //isCpf validacao do GETX
  if (!cpf.isCpf) return 'Digite um CPF válido.';
  return null;
}
