part of 'validation_bloc.dart';

enum ValidationStatus { unkonwn, loading, valid, invalid, filtered, selected }

class ValidationState {
  final List<PhoneCodeModel> codeList;
  final PhoneCodeModel code;
  final String phoneNum;
  final String message;
  final String filterText;
  final ValidationStatus status;

  ValidationState._(
      {this.code = const PhoneCodeModel("Hong Kong", "+ 852", "HK"),
      this.phoneNum = "",
      this.codeList = const [],
      this.message = "",
      this.filterText = "",
      this.status = ValidationStatus.unkonwn});

  ValidationState.initial() : this._();
  ValidationState.filtered(List<PhoneCodeModel> list, String filter)
      : this._(
            codeList: list,
            status: ValidationStatus.filtered,
            filterText: filter);
  ValidationState.selected(PhoneCodeModel code)
      : this._(code: code, status: ValidationStatus.selected);

  ValidationState.loading() : this._(status: ValidationStatus.loading);
  ValidationState.validate(
      String phone, String message, ValidationStatus status)
      : this._(phoneNum: phone, message: message, status: status);
}
