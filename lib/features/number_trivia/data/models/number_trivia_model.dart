import 'package:flutter/foundation.dart';

import '../../domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  NumberTriviaModel({@required String text, @required int number})
      : super(text: text, number: number);

  factory NumberTriviaModel.fromJSON(Map<String, dynamic> json) {
    return NumberTriviaModel(
        text: json["text"], number: (json["number"]).toInt());
  }

  Map<String, dynamic> toJson() {
    return {"text": text, "number": number};
  }
}
