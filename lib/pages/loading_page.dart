import 'package:flutter/material.dart';
import 'package:formbloc_app/providers/admins_provider.dart';
import 'package:formbloc_app/providers/user_provider.dart';
import 'package:formbloc_app/user_preferences/user_preferences.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Container(
                //   child: Text("Ingresando"),
                //   padding: EdgeInsets.only(bottom: 30),
                // ),
                // Logo(
                //   titulo: '',
                // ),
                CircularProgressIndicator(),
              ],
          ));
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final UserPreferences userPreferences = new UserPreferences();
    final UserProvider userProvider = new UserProvider();
    final AdminsProvider adminsProvider = new AdminsProvider();
    final authenticated = await userProvider.checkToken(userPreferences.refreshToken);
    if (authenticated) {
      final currentUserIsAdmin = await adminsProvider.isAdmin(userPreferences.uid);
      Navigator.pushReplacementNamed(context, 'home_page', arguments: currentUserIsAdmin);
    } else {
      Navigator.pushReplacementNamed(context, 'login_page');
    }
  }
}