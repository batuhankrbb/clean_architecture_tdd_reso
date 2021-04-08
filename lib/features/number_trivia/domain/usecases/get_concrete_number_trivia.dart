import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/number_trivia.dart';

import '../repositories/number_trivia_repository.dart';


 //* Burada bi çıtır kafan karışmış olabilir knk normal çünkü param insanın gözünü korkutuyo. Neyse takma sen bunu. Kısacası Dönüş tipini belirttiğimiz içinde call metodu olan bi base use-case sınıfı yaptık onu implement ediyoruz artık. 
 
class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}


/*

  Future<Either<Failure, NumberTrivia>> call({@required int number}) async{
    return await repository.getConcreteNumberTrivia(number);
  }
  */

/*
 @override
  Future<Either<Failure, NumberTrivia>> call(int number) async {
    return await repository.getConcreteNumberTrivia(number);
  }
*/
