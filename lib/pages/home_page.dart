import 'package:flutter/material.dart';
import 'package:formbloc_app/bloc/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginBloc = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Email: ${loginBloc.email}'),
            Text('Password: ${loginBloc.password}'),
          ],
        ),
      ),
    );
  }
}