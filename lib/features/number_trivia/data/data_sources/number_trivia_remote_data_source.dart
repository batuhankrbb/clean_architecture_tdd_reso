import 'package:flutter_clean_architecture_reso/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource { //remote içinde aynı şey geçerli repo buna bakıcak. Sadece bu metodların verini çekip çekmediğindem ve hatalardan sorumlu olucak. İnternetten nasıl veri çekildği reponun umrunda değil
// Mesela JSON'dan çekeriz, XML den çekeriz, ne bileyim byte ile gelir vb vb ne olursa olsun ve modele nasıl çevirirsek çevirelim reponun bilmemesi lazım. Onun burada bilmesi gereken şey şu modelin gelip gelmediği ve hatalar. Örneğin http ile mi çekiyosun dio ile mi sorusunun cevabını repo bilirse yanlış bir şey yapıyorsun demektir.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}
