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
        // _prefs.token = decodedData['idToken'];
        // _prefs.refreshToken = decodedData['refreshToken'];
        
        await sendEmailVerification(decodedData['idToken']);
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
        Map<String, dynamic> resp = new Map();

        //verificar que ya se ha verificado el email
        final emailVerifiedResponse = await isEmailVerified(decodedData['idToken']);
        if (!emailVerifiedResponse['ok']) {
          resp['ok'] = false;
          resp['message'] = emailVerifiedResponse['message'];
          return resp;
        }

        _prefs.token = decodedData['idToken'];
        _prefs.refreshToken = decodedData['refreshToken'];
        _prefs.uid = decodedData['localId'];
        resp['ok'] = true;
        resp['uid'] = decodedData['localId'];
        resp['idToken'] = decodedData['idToken'];
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
  
  Future <Map<String, dynamic>> getUserData(String idToken) async{
    try {
      final authData = {
        'idToken' : idToken,
        'returnSecureToken': true,      
      };

      final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=$_firebaseApiKey');

      final resp = await http.post(
        url,
        body: json.encode(authData)
      );

      Map<String, dynamic> decodedData = json.decode(resp.body);
      if (resp.statusCode == 200) {
        // code 200
        final resp = {
          'ok': true,
          'userData': decodedData
        };
        // print(resp);
        return resp;
      } else {
        // code != 200
        print('error en getUserData');
        final resp = {
          'ok': false,
          'message': decodedData['error']['message']
        };
        print(resp);
        return resp;
      }
    } catch (e) {
      print('error en getUserData');
      print(e);
      final resp = {
        'ok': false,
        'message': e.toString()
      };      
      return resp;
    }
  }

  Future <Map<String, dynamic>> sendEmailVerification(String idToken) async{
    try {
      final authData = {
        'idToken' : idToken,
        'requestType': 'VERIFY_EMAIL',      
      };

      final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=$_firebaseApiKey');

      final resp = await http.post(
        url,
        body: json.encode(authData)
      );

      Map<String, dynamic> decodedData = json.decode(resp.body);
      if (resp.statusCode == 200) {
        // code 200
        final resp = {
          'ok': true,
        };
        // print(resp);
        return resp;
      } else {
        // code != 200
        print('error en sendEmailVerification');
        final resp = {
          'ok': false,
          'message': decodedData['error']['message']
        };
        print(resp);
        return resp;
      }
    } catch (e) {
      print('error en sendEmailVerification');
      print(e);
      final resp = {
        'ok': false,
        'message': e.toString()
      };      
      return resp;
    }
  }

  Future<Map<String, dynamic>> isEmailVerified(String idToken) async {
    try {
      final result = await getUserData(idToken);
      Map<String, dynamic> resp = new Map();
      if (result['ok']) {
        bool isVerified = result['userData']['users'][0]['emailVerified'];
        resp['ok'] = isVerified;
        if (!isVerified) {
          resp['message'] = 'email no ha sido verificado aún';
        }        
      }else{
        resp['ok'] = false;
        resp['message'] = result['message'];
      }
      return resp;
    } catch (e) {
      print('error en isEmailVerified');
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