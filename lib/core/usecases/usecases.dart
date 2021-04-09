
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../error/failures.dart';

//* Bu bizim UseCase base sınıfımız. Kısacası artık bundan sonra Use Caseleri bundan türeticez.
abstract class UseCase<Type, Params>{ //* Bunlar Generic. Type result daki success type. Params da adı üstünde metodda alacağımız parametreler. Aslında Parametre belirlemeye gerek yok ama bu sınıf içinde bu parametreleri belki print vb etmek isteyebiliriz o yüzden almamız iyi olur.

  Future<Either<Failure,Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}


class Params extends Equatable {
  final int number;

  Params({@required this.number});

  @override
  List<Object> get props => [number];
}
