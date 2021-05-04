import 'package:flutter/material.dart';

import 'package:formbloc_app/bloc/provider.dart';
import 'package:formbloc_app/providers/admins_provider.dart';
import 'package:formbloc_app/providers/user_provider.dart';
import 'package:formbloc_app/utils/utils.dart';

class LoginPage extends StatelessWidget {

  final UserProvider   userProvider   = new UserProvider();
  final AdminsProvider adminsProvider = new AdminsProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _createBackground(context),
          _form(context),
        ],
      ),
    );
  }

  _createBackground(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final purpleBackground = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromRGBO(63, 63, 156, 1.0),
          Color.fromRGBO(90, 70, 178, 1.0),
        ]),
      ),
    );

    final circle = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Color.fromRGBO(255, 255, 255, 0.05)),
    );

    final logo = Container(
      padding: EdgeInsets.only(top: 60),
      child: Column(
        children: [
          Icon(
            Icons.person_pin_circle_rounded,
            color: Colors.white,
            size: 100,
          ),
          SizedBox(
            height: 5,
            width: double.infinity,
          ), // el width de este elemento es el que obliga a la
          // columna a tomar todo el ancho del dispositivo, por ende dar la apariencia de estar centrado
          Text(
            'ProductsApp',
            style: TextStyle(color: Colors.white, fontSize: 25),
          )
        ],
      ),
    );

    return Stack(
      children: [
        purpleBackground,
        Positioned(child: circle, top: 90, left: 30,),
        Positioned(child: circle, top: -50, right: -25,),
        Positioned(child: circle, bottom: -25, left: 175,),
        logo
      ],
    );
  }

  _form(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final loginBloc = Provider.of(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
            child: Container(
              height: 200,
            )
          ),
          Container(
            width: size.width * 0.80,
            padding: EdgeInsets.symmetric(vertical: 50),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3,
                  offset: Offset(0, 5),
                  spreadRadius: 3
                ),
              ],
            ),
            child: Column(
              children: [
                Text('Inicio de sesión', style: TextStyle(fontSize: 20),),
                SizedBox(height: 40,),
                _emailInputField(loginBloc),
                SizedBox(height: 30,),
                _passwordInputField(loginBloc),
                SizedBox(height: 30,),
                _createButton(loginBloc),
              ],
            ),
          ),
          SizedBox(height: 25,),
          GestureDetector(
            child: Text('Crear nueva cuenta'),
            onTap: (){
              loginBloc.changeEmail('');
              loginBloc.changePassword('');
              Navigator.pushReplacementNamed(context, 'register_page');
            },
          ),
          SizedBox(height: 100,)
        ],
      ),
    );
  }

  _emailInputField(LoginBloc loginBloc) {

    return StreamBuilder(
      stream: loginBloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.alternate_email, color: Colors.deepPurple,),
              hintText: 'ejemplo@email.com',
              labelText: 'Correo electrónico',
              // counterText: snapshot.data,
              errorText: snapshot.error,
            ),
            onChanged: (value)=>loginBloc.changeEmail(value),
          ),
        );  
      },
    );
  }

  _passwordInputField(LoginBloc loginBloc) {
    return StreamBuilder(
      stream: loginBloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.lock_outline_rounded, color: Colors.deepPurple,),
              labelText: 'Contraseña',
              // counterText: (snapshot.data!=null) ? '*' * snapshot.data.length : snapshot.data,
              errorText: snapshot.error,
            ),
            onChanged: (value)=>loginBloc.changePassword(value),
          ),
        );
      },
    );
  }

  _createButton(LoginBloc loginBloc) {
    return StreamBuilder(
      stream: loginBloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return ElevatedButton(
          child: Container(        
            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
            child: Text('Ingresar',),
          ),
          style: ElevatedButton.styleFrom(
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
            primary: Colors.deepPurple
          ),
          onPressed: !snapshot.hasData ? null : () async{
            Map<String, dynamic> result = await userProvider.login(loginBloc.email, loginBloc.password);
            if (result['ok']) {
              final currentUserIsAdmin = await adminsProvider.isAdmin(result['uid']);
              loginBloc.changeEmail('');
              loginBloc.changePassword('');
              Navigator.pushReplacementNamed(context, 'home_page', arguments: currentUserIsAdmin);
            } else {
              showAlert(context, 'Error', result['message']);
            }
          },      
        );
      },

    );
  }
}
