import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_reso/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_architecture_reso/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_clean_architecture_reso/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_clean_architecture_reso/injection_container.dart';

class NumberTriviaPage extends StatefulWidget {
  @override
  _NumberTriviaPageState createState() => _NumberTriviaPageState();
}

class _NumberTriviaPageState extends State<NumberTriviaPage> {
  String inputString = "";
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Number Trivia"),
      ),
      body: buildBody(context),
    );
  }

 Widget buildBody(BuildContext context) {
     return Builder(
        builder: (context) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: controller,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Input a number"),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        inputString = value;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //* Top Half
                    BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                      builder: (context, state) {
                        if (state is Empty) {
                          return messageDisplay(context, "Start Searching");
                        } else if (state is Error) {
                          return messageDisplay(
                              context, "${state.errorMessage}");
                        } else if (state is Loading) {
                          return loadingWidget(context);
                        } else if (state is Loaded) {
                          return triviaDisplay(context, state.trivia);
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //* Bottom Half
                    bottomHalfControlsWidget(),
                  ],
                ),
              ),
            ),
          );
        },
      );
  }

  Column bottomHalfControlsWidget() {
    return Column(
      children: [
        Placeholder(
          fallbackHeight: 40,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: RaisedButton(
                child: Text(
                  "Search",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.orange,
                onPressed: getConcreteNumberRequest,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: RaisedButton(
                child: Text(
                  "Get Random Trivia",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.pink,
                onPressed: getRandomNumberRequest,
              ),
            ),
          ],
        )
      ],
    );
  }

  void getConcreteNumberRequest() {
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(inputString));
    controller.clear();
  }

  void getRandomNumberRequest() {
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
    controller.clear();
  }

  Center loadingWidget(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height / 3,
            child: CircularProgressIndicator()),
      ),
    );
  }

  Container messageDisplay(BuildContext context, String message) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: SingleChildScrollView(
          child: Text(
            message,
            style: TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget triviaDisplay(BuildContext context, NumberTrivia triviaEntity) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "${triviaEntity.number}",
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
              ),
              Text(
                "${triviaEntity.text}",
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
