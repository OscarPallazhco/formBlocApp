import 'dart:async';

import 'package:formbloc_app/bloc/validators.dart';

class LoginBloc with Validators{

  final _emailCtrller = StreamController<String>.broadcast();
  final _passwordCtrller = StreamController<String>.broadcast();

  Stream<String> get emailStream => _emailCtrller.stream.transform(validateEmail);
  Stream<String> get passwordStream => _passwordCtrller.stream.transform(validatePassword);

  Function(String) get changeEmail => _emailCtrller.sink.add;
  Function(String) get changePassword => _passwordCtrller.sink.add;

  dispose(){
    this._emailCtrller?.close();
    this._passwordCtrller?.close();
  }

}