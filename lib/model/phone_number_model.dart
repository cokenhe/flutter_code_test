import 'package:code_test/model/phone_code_model.dart';

class PhoneNumberModel {
  final PhoneCodeModel code;
  final String phoneNum;

  PhoneNumberModel(this.code, this.phoneNum);

  factory PhoneNumberModel.fromJson(Map<String, dynamic> map) {
    return PhoneNumberModel(
        PhoneCodeModel.fromJson(map["code"]), map["phoneNum"]);
  }

  Map toJsonEncodable() {
    Map<String, dynamic> map = new Map();
    map["code"] = code.toJsonEncodable();
    map["phoneNum"] = phoneNum;

    return map;
  }
}
