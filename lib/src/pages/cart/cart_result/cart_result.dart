import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_result.freezed.dart';

@freezed
//<T> e um tipo abstrato
class CartResult<T> with _$CartResult<T> {
  factory CartResult.success(T data) = Success;
  factory CartResult.error(String message) = Error;
}
