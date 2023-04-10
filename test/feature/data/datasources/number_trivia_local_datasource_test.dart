import 'dart:convert';

import 'package:clean_architecutre_reso_coder/core/error/exceptions.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/data/data_sources/number_trivia_local_datasource.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSource? dataSource;
  MockSharedPreferences? mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences!);
  });
  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
        'should return Number Trivia from sharedpreference when there is one in the cache',
        () async {
      //arrange
      when(mockSharedPreferences!.getString(any))
          .thenReturn(fixture('trivia_cached.json'));
      //act
      final result = await dataSource!.getLastNumberTrivia();

      //assert
      verify(mockSharedPreferences!.getString(CACHED_NUMBER_TRIVIA));
      expect(result, tNumberTriviaModel);
    });
    test('should throw an error when there is no shared value', () async {
      //arrange
      when(mockSharedPreferences!.getString(any)).thenReturn(null);
      //act
      final result = dataSource!.getLastNumberTrivia;

      //assert
      expect(result, throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel = NumberTriviaModel(text: 'test', number: 1);
    test('should call Shared Preference to cache the data', () async {
      //act
      dataSource!.cacheNumberTrivia(tNumberTriviaModel);
      //assert
      final expectedJson = json.encode(tNumberTriviaModel);
      verify(
          mockSharedPreferences!.setString(CACHED_NUMBER_TRIVIA, expectedJson));
    });
  });
}
