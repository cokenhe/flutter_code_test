import 'package:code_test/splash_page.dart';
import 'package:code_test/validation_page/bloc/validation_bloc.dart';
import 'package:code_test/validation_page/validation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

Future main() async {
  await DotEnv.load(fileName: ".env");
  runApp(Application());
}

class Application extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ValidationBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Code Test',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ValidationPage(),
        onGenerateRoute: (_) => SplashPage.route(),
      ),
    );
  }
}
