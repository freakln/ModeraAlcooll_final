import 'package:flutter/material.dart';

import 'paginas/inicio.dart';
import 'paginas/perguntas.dart';
import 'services/authentication.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final BaseAuth auth = new Auth();
  void _logar() async {
    String userId = " ";
    userId = await auth.signIn(
        emailController.toString(), senhaController.toString());
    if (userId != " ") {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Formulario(estado: "MG", idade: "20")),
      );
    }
  }

  void _cadastrar() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Inicio()),
    );
  }

  void _perguntas() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Formulario()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      controller: emailController,
    );

    final passwordField = TextField(
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Senha",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      controller: senhaController,
    );
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.blue,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: _perguntas,
        child: Text("Entrar",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final cadastrarButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.blue,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: _cadastrar,
        child: Text("Cadastrar",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 100.0,
                  child: Image.asset(
                    "assets/logo.jpg",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 42.0),
                emailField,
                SizedBox(height: 23.0),
                passwordField,
                SizedBox(
                  height: 35.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: loginButon,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: cadastrarButon,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
