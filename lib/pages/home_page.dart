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
      body: Container(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.pushNamed(context, 'product_page');
        },
      ),
    );
  }
}