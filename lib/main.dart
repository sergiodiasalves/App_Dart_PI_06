import 'package:flutter/material.dart';

import 'boasvindas_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Autenticação',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BoasVindasPage(),
    );
  }
}

