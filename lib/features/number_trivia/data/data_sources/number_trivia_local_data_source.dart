import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource { //Buraları da abstract yapıp dependency inversion prensibinden yararlanıyoruz. Gördüğün gibi lokal veri kaynağıyla ilgili hiçbir şey belirtilmemiş yani shared preferences mi olucak, hive mi olucak belli değil sadece yaptıkları işler belli
//bunun sebebi de şu: Yarın bigün sharedpreferences kullanımından hive kullanımına geçince veya sqflite kullanımına geçince bizim repository'nin data layerdeki kısmı bunu bilmesin yani repository'nin hiç haberi olmasın. O sadece verinin gelip gelmeyeceğine ve hataya bakıyor veri çekmek ile ilgili. Verinin çekilme yöntemini bilmemesi lazım.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaModel);

}
