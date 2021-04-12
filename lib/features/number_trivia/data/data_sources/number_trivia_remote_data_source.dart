import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  //remote içinde aynı şey geçerli repo buna bakıcak. Sadece bu metodların verini çekip çekmediğindem ve hatalardan sorumlu olucak. İnternetten nasıl veri çekildği reponun umrunda değil
// Mesela JSON'dan çekeriz, XML den çekeriz, ne bileyim byte ile gelir vb vb ne olursa olsun ve modele nasıl çevirirsek çevirelim reponun bilmemesi lazım. Onun burada bilmesi gereken şey şu modelin gelip gelmediği ve hatalar. Örneğin http ile mi çekiyosun dio ile mi sorusunun cevabını repo bilirse yanlış bir şey yapıyorsun demektir.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImplementation
    implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImplementation({@required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    return _getTriviaFromUrl("http://numbersapi.com/$number");
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() {
    return _getTriviaFromUrl("http://numbersapi.com/random");
  }

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    final response = await client.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
    });
    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body);
      return NumberTriviaModel.fromJSON(decodedResponse);
    } else {
      throw ServerException();
    }
  }
}
