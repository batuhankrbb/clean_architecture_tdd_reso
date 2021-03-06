import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../../../../core/util/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = "Server Failure";
const String CACHE_FAILURE_MESSAGE = "Cache Failure";
const String INVALID_INPUT_FAILURE_MESSAGE =
    "Invalid Input Failure - Number must be a positive integer or zero";

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  NumberTriviaBloc(
      {@required this.getConcreteNumberTrivia,
      @required this.getRandomNumberTrivia,
      @required this.inputConverter})
      : super(Empty());

  final GetConcreteNumberTrivia getConcreteNumberTrivia; //Use cases
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final donusturulmusInput =
          inputConverter.stringToUnsignedInteger(event.numberString);

      yield* donusturulmusInput.fold((failure) async* {
        yield Error(errorMessage: INVALID_INPUT_FAILURE_MESSAGE);
      }, (successfullyConvertedNumber) async* {
        yield Loading();
        final failureOrTrivia = await getConcreteNumberTrivia(
            Params(number: successfullyConvertedNumber));
        yield* _foldEitherandYieldState(failureOrTrivia);
      });
    } else if (event is GetTriviaForRandomNumber) {
      yield Loading();
      final failureOrTrivia = await getRandomNumberTrivia(NoParams());
      yield* _foldEitherandYieldState(failureOrTrivia);
    }
  }

  Stream<NumberTriviaState> _foldEitherandYieldState(
      //burada bildi??in use-case den d??nen tip olan either'i al??yoruz ve failure ise failure yield ediyoruz success ise loaded
      Either<Failure, NumberTrivia> failureOrTrivia) async* {
    yield failureOrTrivia.fold(
        (failure) => Error(errorMessage: _mapFailureToMessage(failure)),
        (trivia) => Loaded(trivia: trivia));
  }
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE;
    case CacheFailure:
      return CACHE_FAILURE_MESSAGE;
    default:
      return "UNKNOWN ERROR";
  }
}

//? stringToUnsignedInteger metodu Either d??n??yor adam harf vb girmi??se failure d??n??yor (InvalidInputFailure) yoksa inte ??evrilmi?? halini.
//
//? fold metodu. Bu metod ??unu diyo. Hani bu Either type ya. E??er bu Right ise yani ba??ar??l?? ise ifRight() k??sm??na yaz??lan metodu ??al????t??r, e??er bu Left ise yani ba??ar??s??z ise isLeft() k??sm??na yaz??lan metodu ??al????t??r. Switch case yap??p case Success ve case Failure yapm???? gibi d??????nebilirsin.
