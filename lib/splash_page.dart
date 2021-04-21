import 'package:code_test/constant/constant.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SplashPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: kMainColor,
    )
        // Center(
        //   child: Image.asset(
        //     'assets/images/icons/phone-call.png',
        //     width: 128,
        //     color: kMainColor,
        //   ),
        // ),
        );
  }
}
