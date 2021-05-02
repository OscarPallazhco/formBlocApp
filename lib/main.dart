import 'package:flutter/material.dart';

import 'package:formbloc_app/bloc/provider.dart';
import 'package:formbloc_app/routes/routes.dart';

import 'package:formbloc_app/user_preferences/user_preferences.dart';
 
void main() async{
  final prefs = new UserPreferences();
  WidgetsFlutterBinding.ensureInitialized();
  await prefs.initPrefs();
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'loading_page',
        routes: routes,
        theme: ThemeData(
          primaryColor: Colors.deepPurple
        ),
      ),
    );
  }
}