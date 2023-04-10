// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:clean_architecutre_reso_coder/core/error/exceptions.dart';
import 'package:http/http.dart' as http;

import 'package:clean_architecutre_reso_coder/feature/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel>? getConcreteNumberTrivia(int? number);

  Future<NumberTriviaModel>? getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  late final http.Client client;

  NumberTriviaRemoteDataSourceImpl({
    required this.client,
  });

  @override
  Future<NumberTriviaModel>? getConcreteNumberTrivia(int? number) =>
      _getTriviaFromUrl("http://numbersapi.com/$number");

  @override
  Future<NumberTriviaModel>? getRandomNumberTrivia() =>
      _getTriviaFromUrl("http://numbersapi.com/random");

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    final response = await client.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
