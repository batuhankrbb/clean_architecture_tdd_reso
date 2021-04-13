import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_clean_architecture_reso/core/error/failures.dart';
import 'package:flutter_clean_architecture_reso/core/usecases/usecases.dart';
import 'package:flutter_clean_architecture_reso/core/util/input_converter.dart';
import 'package:flutter_clean_architecture_reso/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_architecture_reso/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_clean_architecture_reso/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

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
      //burada bildiğin use-case den dönen tip olan either'i alıyoruz ve failure ise failure yield ediyoruz success ise loaded
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

//? stringToUnsignedInteger metodu Either dönüyor adam harf vb girmişse failure dönüyor (InvalidInputFailure) yoksa inte çevrilmiş halini.
//
//? fold metodu. Bu metod şunu diyo. Hani bu Either type ya. Eğer bu Right ise yani başarılı ise ifRight() kısmına yazılan metodu çalıştır, eğer bu Left ise yani başarısız ise isLeft() kısmına yazılan metodu çalıştır. Switch case yapıp case Success ve case Failure yapmış gibi düşünebilirsin.
