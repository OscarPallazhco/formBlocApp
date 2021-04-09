import 'dart:async';

class LoginBloc{

  final _emailCtrller = StreamController<String>.broadcast();
  final _passwordCtrller = StreamController<String>.broadcast();

  Stream<String> get emailStream => _emailCtrller.stream;
  Stream<String> get passwordStream => _passwordCtrller.stream;

  Function(String) get changeEmail => _emailCtrller.sink.add;
  Function(String) get changePassword => _passwordCtrller.sink.add;

  dispose(){
    this._emailCtrller?.close();
    this._passwordCtrller?.close();
  }

}