import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:formbloc_app/bloc/validators.dart';

class LoginBloc with Validators{

  final _emailCtrller = BehaviorSubject<String>();
  final _passwordCtrller = BehaviorSubject<String>();
  // cambio de controller a behaviorSubject xq rxdart no los soporta

  Stream<String> get emailStream => _emailCtrller.stream.transform(validateEmail);
  Stream<String> get passwordStream => _passwordCtrller.stream.transform(validatePassword);
  Stream<bool> get formValidStream => 
    Rx.combineLatest2(emailStream, passwordStream, (validEmail, validPassword) => true);
  // combina los dos streams, y si tiene los dos validos, devuelve true, caso contrario null

  Function(String) get changeEmail => _emailCtrller.sink.add;
  Function(String) get changePassword => _passwordCtrller.sink.add;

  String get email => _emailCtrller.value;
  String get password => _passwordCtrller.value;

  dispose(){
    this._emailCtrller?.close();
    this._passwordCtrller?.close();
  }

}