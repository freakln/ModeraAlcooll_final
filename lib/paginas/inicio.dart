import 'package:flutter/material.dart';

import 'formPage.dart';

class Inicio extends StatefulWidget {
  Inicio({Key key}) : super(key: key);

  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  Widget botaosim(String text) {
    return SizedBox(
      width: 150,
      height: 50,
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(40.0),
        color: Colors.blue,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          onPressed: _cadastrar,
          child: Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  void _cadastrar() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Inicio'),
        ),
        resizeToAvoidBottomPadding: false,
        body: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: RichText(
                    text: TextSpan(
                      text:
                          'Minhas respostas podem ser usadas para fazer parte de um banco de dados para estudos sobre o uso de álcool na população?',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Raleway',
                          fontSize: 50.0),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[botaosim("Concordo"), botaosim("Discordo")],
            ),
          ],
        ));
  }
}
