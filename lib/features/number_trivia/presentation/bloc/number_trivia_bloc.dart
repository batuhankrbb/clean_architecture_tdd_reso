import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
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
      final donusturulmusInput = inputConverter.stringToUnsignedInteger(event
          .numberString); //* Either dönüyor adam harf vb girmişse failure dönüyor (InvalidInputFailure) yoksa inte çevrilmiş halini.

     yield* donusturulmusInput.fold((failure) async* {
        //* fold metodu. Bu metod şunu diyo. Hani bu Either type ya. Eğer bu Right ise yani başarılı ise ifRight() kısmına yazılan metodu çalıştır, eğer bu Left ise yani başarısız ise isLeft() kısmına yazılan metodu çalıştır. Switch case yapıp case Success ve case Failure yapmış gibi düşünebilirsin.
        yield Error(errorMessage: INVALID_INPUT_FAILURE_MESSAGE);
      }, (success) {
        throw UnimplementedError(); //burayı daha yazmadık o yüzden şimdilik error fırlat gitsin
      });
    } else if (event is GetTriviaForRandomNumber) {}
  }
}
