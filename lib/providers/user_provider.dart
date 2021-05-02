import 'dart:convert';
import 'package:formbloc_app/user_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:formbloc_app/global/environments.dart';


class UserProvider {

  final String _firebaseApiKey = Environments.firebaseApiKey;
  final _prefs = new UserPreferences();

  Future <Map<String, dynamic>> newUser(String email, String password) async{
    try {
      final authData = {
        'email' : email,
        'password': password,
        'returnSecureToken': true,      
      };

      final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseApiKey');

      final resp = await http.post(
        url,
        body: json.encode(authData)
      );
      
      Map<String, dynamic> decodedData = json.decode(resp.body);
      if (decodedData.containsKey('idToken')) {
        // code 200
        _prefs.token = decodedData['idToken'];
        _prefs.refreshToken = decodedData['refreshToken'];
        final resp = {
          'ok': true,
          'idToken': decodedData['idToken']
        };
        // print(resp);
        return resp;
      } else {
        // code != 200
        print('error en newUser');
        final resp = {
          'ok': false,
          'message': decodedData['error']['message']
        };
        print(resp);
        return resp;
      }
    } catch (e) {
      print('error en newUser');
      print(e);
      final resp = {
        'ok': false,
        'message': e.toString()
      };      
      return resp;
    }
  }

  Future <Map<String, dynamic>> login(String email, String password) async{
    try {
      final authData = {
        'email' : email,
        'password': password,
        'returnSecureToken': true,      
      };

      final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseApiKey');

      final resp = await http.post(
        url,
        body: json.encode(authData)
      );
      
      Map<String, dynamic> decodedData = json.decode(resp.body);
      if (decodedData.containsKey('idToken')) {
        // code 200
        _prefs.token = decodedData['idToken'];
        _prefs.refreshToken = decodedData['refreshToken'];
        final resp = {
          'ok': true,
          'idToken': decodedData['idToken']
        };
        // print(resp);
        return resp;
      } else {
        // code != 200
        print('error en login');
        final resp = {
          'ok': false,
          'message': decodedData['error']['message']
        };
        print(resp);
        return resp;
      }
    } catch (e) {
      print('error en login');
      print(e);
      final resp = {
        'ok': false,
        'message': e.toString()
      };      
      return resp;
    }
  }
  
  Future<bool> checkToken(String refreshToken) async{
    try {
      final authData = {
        'grant_type' : 'refresh_token',
        'refresh_token': refreshToken,      
      };

      final url = Uri.parse('https://securetoken.googleapis.com/v1/token?key=$_firebaseApiKey');

      final resp = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        // body: json.encode(authData)
        body: authData
      );
      
      Map<String, dynamic> decodedData = json.decode(resp.body);
      if (decodedData.containsKey('id_token')) {
        // code 200
        _prefs.token = decodedData['id_token'];
        _prefs.refreshToken = decodedData['refresh_token'];
        final resp = {
          'ok': true,
          'idToken': decodedData['id_token']
        };
        // print(resp);
        return true;
      } else {
        // code != 200
        print('error en checkToken');
        final resp = {
          'ok': false,
          'message': decodedData['error']['message']
        };
        print(resp);
        return false;
      }
    } catch (e) {
      print('error en checkToken');
      print(e);
      final resp = {
        'ok': false,
        'message': e.toString()
      };
      print(resp);
      return false;
    }
  }
}