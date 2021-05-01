import 'package:flutter/material.dart';

import 'package:formbloc_app/bloc/provider.dart';
import 'package:formbloc_app/routes/routes.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'login_page',
        routes: routes,
        theme: ThemeData(
          primaryColor: Colors.deepPurple
        ),
      ),
    );
  }
}