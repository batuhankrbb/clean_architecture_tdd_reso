import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_reso/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_architecture_reso/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_clean_architecture_reso/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNumberTriviaRepository extends Mock //Sahte Repository
    implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository; //Bu bizim repomuz. Data kısmında doldurduğumuzu düşün. Bu o hali yani Fulfilled hali.

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository(); //Repository
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository); //Use Case (Bunları tanımlarken zaten repo vermek lazımdı)
  });
 
  final testNumber = 1; //test içinde kullanmak için bir number tanımladık
  final testNumberTrivia =
      NumberTrivia(text: "test", number: testNumber); //test içinde kullanmak için bir Entity tanımladık

  test("should get trivia for the number from the repository", () async {
    //Arrange
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(any)) //mocku ayarladık. Ne zaman mock tetiklenirse Success olarak yukarıda kullanmak için tanımladığımız numbertrivia dönecek
        .thenAnswer((realInvocation) async => Right(testNumberTrivia));

    //Act
    final result = await usecase(number: testNumber); //Yukarıda setupda oluşturduğumuz use case'i kullandık

    //Assert
    expect(result, Right(testNumberTrivia)); //gelen sonucu kontrol ettik
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(testNumber)); //Bu sonucun nereden geldiği kesin olsun diye tanımladığımız sahte reponun getConcrete metodu x sayısı ile çalışmış mı diye baktık
    verifyNoMoreInteractions(mockNumberTriviaRepository); //Daha fazla Interaction yapıp yapmadığını kontrol ettik, test içinde ekstradan metod çalıştırılmadığından emin olduk

  });
}


//Kısacası en başta abstract arkasına gizlediğimiz sınıfları mock yaparak fulfill ediyoruz. Daha sonra kontrol edeceğimiz şeyleri tanımlıyoruz mesela burada use case.
//Daha sonra setup kısmında tanımladıklarımızı initialize ediyoruz. Test kısmında ise yapacağımız işlemleri yapıp gelen sonucu expect ile sağlamasını yapıyoruz.