part of 'validation_bloc.dart';

@immutable
abstract class ValidationEvent {}

class UpdatePhoneEvent extends ValidationEvent {
  final String phone;
  UpdatePhoneEvent(this.phone);
}

class UpdateFilterEvent extends ValidationEvent {
  final String filter;
  UpdateFilterEvent(this.filter);
}

class UpdateCodeEvent extends ValidationEvent {
  final PhoneCodeModel code;
  UpdateCodeEvent(this.code);
}
