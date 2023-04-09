import 'dart:convert';

import 'package:clean_architecutre_reso_coder/feature/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  const numberTriviaModel = NumberTriviaModel(text: 'Test', number: 1);

  test('should be a subclass of NumberTrivia entity', () async {
    //assert
    expect(numberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test(
      'should return a valid number when Json model has an integer',
      () async {
        //arrnge
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia.json'));

        //act
        final result = NumberTriviaModel.fromJson(jsonMap);
        //assert
        expect(result, numberTriviaModel);
      },
    );
  });
  test(
    'should return a valid number when Json model has an double',
    () async {
      //arrnge
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));

      //act
      final result = NumberTriviaModel.fromJson(jsonMap);
      //assert
      expect(result, numberTriviaModel);
    },
  );
  test(
    'should return a valid JSON map containing valid data',
    () async {
      //act
      final result = numberTriviaModel.toJson();
      final expectedMap = {"text": "Test", "number": 1};
      //assert
      expect(result, expectedMap);
    },
  );
}
