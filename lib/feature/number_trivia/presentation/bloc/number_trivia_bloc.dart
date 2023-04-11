// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/util/input_converter.dart';
import '../../domain/use_cases/get_concrete_number_trivia.dart';
import '../../domain/use_cases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(this.getConcreteNumberTrivia, this.getRandomNumberTrivia,
      this.inputConverter)
      : super(Empty()) {
    on<NumberTriviaEvent>((event, emit) async {
      if (event is GetTriviaForConcreteNumber) {
        final inputEither =
            inputConverter.stringToUnsignedInteger(event.numberString);
        inputEither?.fold(
          (failure) {
            emit(const Error(message: INVALID_INPUT_FAILURE_MESSAGE));
          },
          (integer) async {
            emit(Loading());
            final failureOrTrivia =
                await getConcreteNumberTrivia(Params(number: integer));
            _eitherLoadedOrErrorState(failureOrTrivia);
          },
        );
      } else if (event is GetTriviaForRandomNumber) {
        emit(Loading());
        final finalOrTrivia = await getRandomNumberTrivia(NoParams());
        _eitherLoadedOrErrorState(finalOrTrivia);
      }
    });
  }

  void _eitherLoadedOrErrorState(Either<Failure, NumberTrivia>? either) async {
    either?.fold(
      (failure) => emit(Error(message: _mapFailureToMessage(failure))),
      (trivia) => emit(
        Loaded(numberTrivia: trivia),
      ),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
