import 'package:clean_architecutre_reso_coder/core/util/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;
  setUp(() => {inputConverter = InputConverter()});

  group('stringToUnsignedInt', () {
    test('should return an integer when the string represents an unsigned int',
        () async {
      //arrange
      const str = '123';
      //act
      final result = inputConverter.stringToUnsignedInteger(str);
      //assert
      expect(result, const Right(123));
    });
    test('should return a Failure when the string is not an unsigned int',
        () async {
      //arrange
      const str = 'abc';
      //act
      final result = inputConverter.stringToUnsignedInteger(str);
      //assert
      expect(result, Left(InvalidInputFailure()));
    });
    test('should return a Failure when the string is not an negative number',
        () async {
      //arrange
      const str = '-123';
      //act
      final result = inputConverter.stringToUnsignedInteger(str);
      //assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
