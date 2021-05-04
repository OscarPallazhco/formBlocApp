import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:formbloc_app/user_preferences/user_preferences.dart';
import 'package:formbloc_app/global/environments.dart';

class AdminsProvider {

  final String databaseUrl  = Environments.databaseUrl;
  final String cloudName    = Environments.cloudName;
  final _userPreferences     = new UserPreferences();


  Future<List<String>> _getAdmins() async{
    try {
      final String productsUrl = '$databaseUrl/admins.json?auth=${_userPreferences.token}';
      final url = Uri.parse(productsUrl);
      final resp = await http.get(url);

      final Map<String, dynamic> decodedData = json.decode(resp.body);
      // print(decodedData);
      if (decodedData == null ) return [];
      if (decodedData['error'] != null ) return [];
      List<String> uids = [];
      decodedData.forEach((key, value) {
        // en las key vienen los uids de los usuarios que son admins
        uids.add(key);
      });
      return uids;
    } catch (e) {
      print('error en getAdmins');
      print(e);
      return [];
    }
  }

  Future<bool> isAdmin(String uid) async{
    final uids = await _getAdmins();
    for (var _uid in uids) {
      if (_uid == uid) {
        return true;
      }
    }
    return false;
  }
 
}