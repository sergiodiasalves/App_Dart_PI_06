import 'dart:convert';

import 'package:app/home_page.dart';
import 'package:app/register_page.dart';
import 'package:app/reset_password_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric( horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 128,
                height: 128,
                child: Image.asset("assets/10181.png"),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 20
                  ),
                ),
                style: TextStyle(fontSize: 20
                ),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (email){
                  if(email == null || email.isEmpty){
                    return 'Por Favor, digite seu e-mail';
                  }else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(_emailController.text)) {
                      return 'Por favor, digite um e-mail correto';
                    }
                    return null;
                  },
              ),
               SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Senha',
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                )
                ),
                style: TextStyle(fontSize: 20
                ),
                controller: _passwordController,
                obscureText: true,
                keyboardType: TextInputType.text,
                validator: (senha){
                  if (senha == null || senha.isEmpty) {
                    return 'Por favor. digite sua senha';
                  } else if (senha.length < 3) {
                    return 'Por favor, digite uma senha maior que 6 caracteres';
                  }
                  return null;
                  },
              ),
               SizedBox(
                height: 10,
              ),
              Container(
                height: 40,
                alignment: Alignment.centerRight,
                child: TextButton(
                  child: Text(
                  'Recuperar Senha',
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResetPasswordPage(),
                        ),
                        );
                  },
                ),
               ),
               SizedBox(
                height: 40,
              ),
              Container(
                height: 60,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.3, 1],
                    colors: [
                      Colors.green.shade800,
                      Colors.green.shade200,
                    ],
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: SizedBox.expand(
                  child: TextButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          'Entrar   ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Container(
                          child: SizedBox(
                            child: Image.asset("assets/recycling-symbol.png"),
                            height: 28,
                            width: 28,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () async {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if(_formkey.currentState!.validate()){
                    bool deuCerto = await login();
                    if(!currentFocus.hasPrimaryFocus){
                      currentFocus.unfocus();
                    }
                    if(deuCerto) {
                      Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => HomePage(), 
                        ),
                      );
                    }else{
                      _passwordController.clear();
                      ScaffoldMessenger.of(context) .showSnackBar(snackBar);
                    }
                  }
                },
                ),
                ),
              ),
               SizedBox(
                height: 10,
              ),
              Container(
                height: 40,
                child: TextButton(child: Text(
                  "Cadastre-se",
                  textAlign: TextAlign.center,
                  ),
                  onPressed: () async {
                    bool register = await registro();
                    if(register){
                      Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => RegisterPage(),
                        ),
                                                                  
                      );
                    }
                  },
                ),
              ),
            ],
          ) ,
          ),
      )
      )
    );
  }

  final snackBar = SnackBar(
    content: Text(
    'email ou senha são inválidos',
    textAlign: TextAlign.center,
    ), 
    backgroundColor: Colors.redAccent,
     );

     Future<bool> registro() async{
       SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
       await sharedPreferences.clear();
       return true;
     }

  Future<bool> login() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var url = Uri.parse('https://theguardianapi.vercel.app/login/'+_emailController.text+'/'+_passwordController.text);
    var resposta = await http.get(url);
    if(resposta.statusCode == 200) {
      await sharedPreferences.setString('token', "Token ${jsonDecode(resposta.body)['token']}");
      return true;
    }else{
      return false;
    }
  }
}
