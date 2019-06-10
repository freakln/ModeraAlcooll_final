import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:moderalcool/models/cadastro.dart';
import 'package:moderalcool/services/authentication.dart';
import 'package:moderalcool/services/crud.dart';

class PageFormulario extends StatefulWidget {
  @override
  _PageFormularioState createState() => _PageFormularioState();
}

class _PageFormularioState extends State<PageFormulario> {
  final BaseAuth auth = new Auth();
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controller = new TextEditingController();
  CrudMedthods crudObj = new CrudMedthods();
  Cadastro newContact = new Cadastro();
  String _password;

  bool _aceito = true;

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Verifique seu cadastro"),
          content:
              new Text("Link enviado ao seu email para verificar cadastro"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future _chooseDate(BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);

    var result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now());

    if (result == null) return;

    setState(() {
      _controller.text = new DateFormat.yMd().format(result);
    });
  }

  DateTime convertToDate(String input) {
    try {
      var d = new DateFormat.yMd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  bool isValidDob(String dob) {
    if (dob.isEmpty) return true;
    var d = convertToDate(dob);
    return d != null && d.isBefore(new DateTime.now());
  }

  bool isValidEmail(String input) {
    final RegExp regex = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input);
  }

  void _submitForm() async {
    final FormState form = _formKey.currentState;

    if (!form.validate() && _aceito) {
      showMessage(
          'Formulario incorreto gentileza verificar o preenchimento correto.');
    } else {
      form.save(); //This invokes each onSaved event
      String userId = "";
      userId = await auth.signUp(newContact.email, _password);
      auth.sendEmailVerification();
      _showVerifyEmailSentDialog();
      print('Criado usuario: $userId');
    }
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));
  }

  List _escolaridade = [
    "Informe a Escolaridade",
    "fundamental incompleto",
    "fundamental completo",
    "médio completo",
    "medio incompleto",
    "superior completo",
    "superior incompleto",
    "pós-graduação"
  ];

  List _estados = [
    "AC",
    "AL",
    "AM",
    "AP",
    "BA",
    "CE",
    "DF",
    "ES",
    "GO",
    "MA",
    "MT",
    "MS",
    "MG",
    "PA",
    "PB",
    "PR",
    "PE",
    "PI",
    "RJ",
    "RN",
    "RO",
    "RS",
    "RR",
    "SC",
    "SE",
    "SP",
    "TO"
  ];

  List _genero = ["Masculino", "Feminino"];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  List<DropdownMenuItem<String>> _dropDownMenuItems2;
  List<DropdownMenuItem<String>> _dropDownMenuItems3;

  void initState() {
    _dropDownMenuItems = buildAndGetDropDownMenuItems(_escolaridade);
    _dropDownMenuItems2 = buildAndGetDropDownMenuItems2(_genero);
    _dropDownMenuItems3 = buildAndGetDropDownMenuItems2(_estados);

    super.initState();
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List covariant) {
    List<DropdownMenuItem<String>> items = new List();
    for (String nivel in covariant) {
      items.add(new DropdownMenuItem(value: nivel, child: new Text(nivel)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems2(List covariant) {
    List<DropdownMenuItem<String>> items2 = new List();
    for (String gen in covariant) {
      items2.add(new DropdownMenuItem(value: gen, child: new Text(gen)));
    }
    return items2;
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems3(List covariant) {
    List<DropdownMenuItem<String>> items3 = new List();
    for (String gen in covariant) {
      items3.add(new DropdownMenuItem(value: gen, child: new Text(gen)));
    }
    return items3;
  }

  void changedDropDownItem(String escolaridade) {
    setState(() {
      newContact.escolaridade = escolaridade;
    });
  }

  void changedDropDownItem3(String value) {
    setState(() {
      newContact.estado = value;
    });
  }

  void changedDropDownItem2(String genero) {
    setState(() {
      newContact.genero = genero;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text('Cadastro'),
      ),
      body: new SafeArea(
        top: false,
        bottom: false,
        child: new Form(
          key: _formKey,
          autovalidate: false,
          child: new ListView(
            padding: const EdgeInsets.all(10.0),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: new TextFormField(
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Informe seu Apelido',
                    labelText: 'Apelido',
                  ),
                  inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                  validator: (val) =>
                      val.isEmpty ? 'Necessario informar Apelido' : null,
                  onSaved: (val) => newContact.login = val,
                ),
              ),
              new SizedBox(
                height: 20,
              ),
              new Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: new IconButton(
                      icon: new Icon(Icons.date_range),
                      tooltip: 'Informe a data',
                      onPressed: (() {
                        _chooseDate(context, _controller.text);
                      }),
                    ),
                  ),
                  new Expanded(
                    child: new TextFormField(
                      decoration: new InputDecoration(
                        hintText: 'Informe a data de nascimento',
                        labelText: 'Nascimento',
                      ),
                      controller: _controller,
                      keyboardType: TextInputType.datetime,
                      validator: (val) =>
                          isValidDob(val) ? null : 'Data invalida',
                      onSaved: (val) => newContact.data = convertToDate(val),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 40, 0),
                        child: Text(
                          "UF:",
                          textAlign: TextAlign.left,
                        ),
                      ),
                      new DropdownButton(
                        value: newContact.estado,
                        items: _dropDownMenuItems3,
                        onChanged: changedDropDownItem3,
                        hint: Text("Estado"),
                      ),
                    ],
                  )
                ],
              ),
              new SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Icon(
                      Icons.school,
                      color: Colors.black38,
                      size: 30.0,
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: Text(
                          "Informe sua escolaridade",
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: new DropdownButton(
                          value: newContact.escolaridade,
                          items: _dropDownMenuItems,
                          onChanged: changedDropDownItem,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Icon(
                      Icons.perm_identity,
                      color: Colors.black38,
                      size: 30.0,
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 90),
                        child: Text(
                          "Sexo:",
                          textAlign: TextAlign.left,
                        ),
                      ),
                      new DropdownButton(
                        value: newContact.genero,
                        items: _dropDownMenuItems2,
                        onChanged: changedDropDownItem2,
                        hint: Text("Informe o sexo"),
                      ),
                    ],
                  ),
                ],
              ),
              new SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: new TextFormField(
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.attach_money),
                    hintText: 'Informe sua renda',
                    labelText: 'Renda',
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    new WhitelistingTextInputFormatter(
                        new RegExp(r'^\d+(?:\.\d{0,2})?$')),
                  ],
                  onSaved: (val) => newContact.renda = double.parse(val),
                ),
              ),
              new SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: new TextFormField(
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.email),
                    hintText: 'Informe o e-mail',
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => isValidEmail(value)
                      ? null
                      : 'Por favor informe um e-mail valido',
                  onSaved: (val) => newContact.email = val,
                ),
              ),
              new SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: new TextFormField(
                  obscureText: true,
                  maxLines: 1,
                  autofocus: false,
                  decoration: new InputDecoration(
                      hintText: 'Senha',
                      icon: new Icon(
                        Icons.lock,
                        color: Colors.grey,
                      )),
                  validator: (value) =>
                      value.isEmpty ? 'A senha não pode ser vazia' : null,
                  onSaved: (value) => _password = value,
                ),
              ),
              new SizedBox(
                height: 20,
              ),
              new Container(
                padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.blue,
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    onPressed: _submitForm,
                    child: Text(
                      "Cadastrar",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
