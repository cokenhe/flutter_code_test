import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:code_test/model/phone_code_model.dart';
import '../../constant/phone_code.dart';

part 'validation_event.dart';
part 'validation_state.dart';

class ValidationBloc extends Bloc<ValidationEvent, ValidationState> {
  ValidationBloc() : super(ValidationState.initial());

  final List<PhoneCodeModel> codeList = PhoneCodeModel.fromJsonList(phone_code);
  PhoneCodeModel code = PhoneCodeModel.initialize();

  @override
  Stream<ValidationState> mapEventToState(
    ValidationEvent event,
  ) async* {
    if (event is UpdateCodeEvent) {
      code = event.code;
      yield ValidationState.selected(event.code);
    }
    if (event is UpdateFilterEvent) {
      final filter = event.filter;
      yield ValidationState.filtered(
          codeList.where((code) => code.codeFilter(filter)).toList(), filter);
    }
    if (event is UpdatePhoneEvent) {
      final String phone = event.phone;
      final String domain = env["PHONE_VALIDATION_DOMAIN"];
      final String api = env["PHONE_VALIDATION_API"];
      final String key = env["ACCESS_KEY"];

      yield ValidationState.loading();

      final response = await http.get(Uri.http(domain, api,
          {"access_key": key, "number": phone, "country_code": code.isoCode}));

      ValidationStatus status = ValidationStatus.invalid;
      String message = "";
      final bool isValid = jsonDecode(response.body)["valid"];

      if (response.statusCode == 200 && isValid != null) {
        if (isValid) {
          message = "The number is valid.\nRedirecting to next page...";
          status = ValidationStatus.valid;
        } else
          message = "The number is not valid.";
      } else
        message = jsonDecode(response.body)["error"]["info"];

      yield ValidationState.validate(phone, message, status);
    }
  }
}
