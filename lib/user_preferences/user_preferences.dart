import 'package:shared_preferences/shared_preferences.dart';

/*
  Recordar instalar el paquete de:
    shared_preferences:

  Inicializar en el main
    final prefs = new UserPreferences();
    await prefs.initPrefs();
    
    Recuerden que el main() debe de ser async {...

*/

class UserPreferences {

  static final UserPreferences _instance = new UserPreferences._internal();

  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del token
  get token {
    return _prefs.getString('token') ?? '';
  }

  set token( String value ) {
    _prefs.setString('token', value);
  }

  // GET y SET del refresh token
  get refreshToken {
    return _prefs.getString('refreshToken') ?? '';
  }

  set refreshToken( String value ) {
    _prefs.setString('refreshToken', value);
  }
  

  // GET y SET de la última página
  get lastpage {
    return _prefs.getString('lastpage') ?? 'login_page';
  }

  set lastpage( String value ) {
    _prefs.setString('lastpage', value);
  }

  void logout(){
    _prefs.remove('token');
    _prefs.remove('refreshToken');
  }

}

