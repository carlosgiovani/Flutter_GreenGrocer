import 'package:flutter_test/flutter_test.dart';
import 'package:greengrocer/src/pages/commons_widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class EmailValidator {
  validate({String? email}) {
    if (email == null || email == '') {
      return 'O e-mail é obrigatorio';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'E-mail inválido';
    }
    return null;
  }
}

void main() {
  late EmailValidator emailValidator;

  setUp(() {
    emailValidator = EmailValidator();
  });

  group('Validação de e-mail', () {
    test('Deve retornar uma mensagem de erro caso o e-mail seja null', () {
      final result = emailValidator.validate();
      expect(result, equals('O e-mail é obrigatorio'));
    });

    test('Deve retornar uma mensgem de erro caso o e-mail seja vazio', () {
      final result = emailValidator.validate(email: '');
      expect(result, equals('O e-mail é obrigatorio'));
    });

    test('Deve retornar uma mensagem de erro caso o e-mail seja inválido', () {
      final result = emailValidator.validate(email: 'nome');
      expect(result, equals('E-mail inválido'));
    });

    test('Deve retornar null caso o e-mail seja válido', () {
      final result = emailValidator.validate(email: 'nome@email.com');
      expect(result, isNull);
    });
  });
}
