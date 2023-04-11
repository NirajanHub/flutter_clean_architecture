// ignore_for_file: sized_box_for_whitespace
import 'package:clean_architecutre_reso_coder/feature/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Number Trivia')),
      body: buildBody(context),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: <Widget>[
            const SizedBox(
              height: 10.0,
            ),
            BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
              builder: (context, state) {
                if (state is Empty) {
                  return const MessageDisplay(message: 'Start searching');
                } else if (state is Loading) {
                  return const LoadingWidget();
                } else if (state is Loaded) {
                  TriviaDisplay(numberTrivia: state.numberTrivia);
                } else if (state is Error) {
                  return MessageDisplay(message: state.message);
                } else {}
                throw Exception();
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TriviaControls()
          ]),
        ),
      ),
    );
  }
}

class TriviaControls extends StatefulWidget {
  String inpStr;
  const TriviaControls({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
         TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number'
          )
          ,onChanged : (value) {
          inpStr = value;
        }),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: const <Widget>[
            Expanded(
                child: Placeholder(
              fallbackHeight: 30,
            )),
            SizedBox(width: 10),
            Expanded(
                child: Placeholder(
              fallbackHeight: 30,
            )),
          ],
        )
      ],
    );
  }
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
  

}



