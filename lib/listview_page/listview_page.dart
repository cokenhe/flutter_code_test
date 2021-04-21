import 'package:code_test/constant/constant.dart';
import 'package:code_test/model/phone_number_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class ListViewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  final LocalStorage storage = new LocalStorage(kLSKey);
  bool initialized = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
            future: storage.ready,
            builder: (context, snapshot) {
              List<PhoneNumberModel> list;

              if (snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              }

              if (!initialized) {
                final List items = storage.getItem(kLSPhoneNumberKey);

                if (items != null) {
                  list = List<PhoneNumberModel>.from(
                      items.map((item) => PhoneNumberModel.fromJson(item)));
                  initialized = true;
                }
              }

              return ListView.builder(
                  itemCount: list?.length ?? 0,
                  itemBuilder: (context, index) => buildListTile(list[index]));
            }));
  }

  ListTile buildListTile(PhoneNumberModel phone) {
    return ListTile(
        leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [phone.code.getImage()]),
        title: RichText(
            text: TextSpan(children: [
          TextSpan(
              text: "${phone.code.dialCode} ",
              style: TextStyle(color: Colors.grey)),
          TextSpan(
              text: phone.phoneNum, style: TextStyle(color: Colors.black87)),
        ])),
        trailing: Text(phone.code.name));
  }
}
