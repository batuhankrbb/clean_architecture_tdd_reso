import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_reso/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'injection_container.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  var preferences = SharedPreferences.getInstance();
  preferences.then((value) {
    init(value);
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
        accentColor: Colors.green.shade600,
      ),
      home: BlocProvider(
        create: (_) => getIt<NumberTriviaBloc>(),
        child: Builder(
          builder: (_) => NumberTriviaPage(),
        ),
      ),
    );
  }
}
