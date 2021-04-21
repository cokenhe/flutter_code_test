import 'dart:async';

import 'package:code_test/listview_page/listview_page.dart';
import 'package:code_test/model/phone_number_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstorage/localstorage.dart';

import '../constant/phone_code.dart';
import '../constant/constant.dart';
import '../model/phone_code_model.dart';
import 'bloc/validation_bloc.dart';

class ValidationPage extends StatefulWidget {
  ValidationPage({Key key}) : super(key: key);

  @override
  _ValidationPageState createState() => _ValidationPageState();
}

class _ValidationPageState extends State<ValidationPage> {
  final List<PhoneCodeModel> codeList = PhoneCodeModel.fromJsonList(phone_code);
  final LocalStorage storage = new LocalStorage(kLSKey);
  List<PhoneNumberModel> list = [];

  @override
  void initState() {
    super.initState();
    storage.ready.then((ready) {
      final List items = storage.getItem(kLSPhoneNumberKey);
      if (items == null) return;
      list = items.map((item) => PhoneNumberModel.fromJson(item)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildDescription(),
        Padding(padding: EdgeInsets.all(kLargePadding / 2)),
        buildPhoneRow(context),
        Padding(padding: EdgeInsets.all(kSmallPadding)),
        buildMsgRow(context),
        Padding(padding: EdgeInsets.all(kLargePadding * 2))
      ],
    )));
  }

  Column buildDescription() {
    return Column(
      children: [
        Image.asset(
          "assets/images/icons/phone-call.png",
          color: kMainColor,
          width: 96,
        ),
        Padding(padding: EdgeInsets.all(kSmallPadding)),
        Text("Check your number!",
            style: TextStyle(color: kMainColor, fontSize: 24)),
        Padding(padding: EdgeInsets.all(kSmallPadding)),
        Text("Enter a number blow and\nvalidate if it correct!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 16))
      ],
    );
  }

  Widget buildMsgRow(BuildContext context) {
    return BlocBuilder<ValidationBloc, ValidationState>(
        builder: (context, state) {
      Icon icon;
      Color color;
      switch (state.status) {
        case ValidationStatus.valid:
          color = kSuccessColor;
          icon = Icon(Icons.check_circle_outlined, color: color);
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ListViewPage()));
          });
          break;
        case ValidationStatus.invalid:
          color = kFailureColor;
          icon = Icon(Icons.cancel_outlined, color: color);
          list.add(PhoneNumberModel(state.code, state.phoneNum));
          storage.setItem(
              kLSPhoneNumberKey, list.map((e) => e.toJsonEncodable()).toList());
          break;
        case ValidationStatus.loading:
          return Center(child: CircularProgressIndicator());
          break;
        default:
          return Container();
      }
      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icon,
            Padding(padding: EdgeInsets.all(kSmallPadding)),
            Text(state.message,
                textAlign: TextAlign.center, style: TextStyle(color: color))
          ]);
    });
  }

  Widget buildPhoneRow(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(padding: EdgeInsets.all(kSmallPadding)),
          Flexible(flex: 4, child: buildBottomSheetBtn(context)),
          Padding(padding: EdgeInsets.all(kSmallPadding)),
          Flexible(flex: 6, child: buildPhoneTextField(context)),
          Padding(padding: EdgeInsets.all(kSmallPadding)),
        ]);
  }

  TextField buildPhoneTextField(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      onSubmitted: (phone) {
        print(phone);
        context.read<ValidationBloc>().add(UpdatePhoneEvent(phone));
      },
      style: TextStyle(
          color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
          border:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
          hintText: 'Enter a phone number'),
    );
  }

  Widget buildBottomSheetBtn(BuildContext context) {
    return BlocBuilder<ValidationBloc, ValidationState>(
      builder: (context, state) {
        return DecoratedBox(
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey))),
            child: TextButton(
                child: Row(children: [
                  state.code.getImage(),
                  Padding(padding: EdgeInsets.all(kSmallPadding)),
                  Text(state.code.dialCode,
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  Padding(padding: EdgeInsets.all(kSmallPadding)),
                  Icon(Icons.arrow_drop_down)
                ]),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: buildBottomSheetModal);
                }));
      },
    );
  }

  Container buildBottomSheetModal(BuildContext context) {
    return Container(
        height: 300,
        child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
              TextField(
                onChanged: (filter) {
                  print(filter);
                  context.read<ValidationBloc>().add(UpdateFilterEvent(filter));
                },
                onSubmitted: print,
              ),
              Expanded(child: buildListView(context))
            ])));
  }

  Widget buildListView(BuildContext context) {
    return BlocBuilder<ValidationBloc, ValidationState>(
      builder: (context, state) {
        final filter = state.filterText;
        final codeList = (state.codeList.length == 0 && filter.length == 0)
            ? this.codeList
            : state.codeList;
        return ListView(
            children: codeList
                .map((code) => ListTile(
                    leading: code.getImage(),
                    title: RichText(
                        text: TextSpan(
                            text: "${code.name}\t\t",
                            style:
                                TextStyle(color: Colors.black87, fontSize: 16),
                            children: [
                          TextSpan(
                              text: code.dialCode,
                              style: TextStyle(color: Colors.grey))
                        ])),
                    onTap: () {
                      print(code);
                      context.read<ValidationBloc>().add(UpdateCodeEvent(code));
                      Navigator.of(context).pop();
                    }))
                .toList());
      },
    );
  }
}
