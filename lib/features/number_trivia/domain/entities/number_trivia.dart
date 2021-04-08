import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

//Modelin ViewModeli diye yaptığım şey işte masajlanmış model
class NumberTrivia extends Equatable {
  final String text;
  final int number;

  NumberTrivia({@required this.text, @required this.number});

  @override
  List<Object> get props => [number,text];
}
