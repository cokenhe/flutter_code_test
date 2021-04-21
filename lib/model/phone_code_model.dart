import 'dart:core';

import 'dart:ui';

import 'package:flutter/widgets.dart';

class PhoneCodeModel {
  final String name;
  final String dialCode;
  final String isoCode;

  const PhoneCodeModel(this.name, this.dialCode, this.isoCode);

  factory PhoneCodeModel.initialize() {
    return PhoneCodeModel("Hong Kong", "+852", "HK");
  }

  factory PhoneCodeModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return PhoneCodeModel(json["name"], json["dialCode"], json["isoCode"]);
  }

  static List<PhoneCodeModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => PhoneCodeModel.fromJson(item)).toList();
  }

  Widget getImage() {
    try {
      return Image.asset('assets/images/flags/${isoCode.toLowerCase()}.png');
    } on Exception catch (_) {
      return Container();
    }
  }

  bool codeFilter(String filter) {
    final lowerFilter = filter.toLowerCase();
    return name.toLowerCase().contains(lowerFilter) ||
        isoCode.toLowerCase().contains(lowerFilter) ||
        dialCode.contains(lowerFilter);
  }

  bool isEqual(PhoneCodeModel model) {
    return this?.isoCode == model?.isoCode;
  }

  @override
  String toString() => name;

  Map toJsonEncodable() {
    Map<String, String> map = new Map();
    map["name"] = name;
    map["dialCode"] = dialCode;
    map["isoCode"] = isoCode;

    return map;
  }
}
