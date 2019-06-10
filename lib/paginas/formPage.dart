import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:moderalcool/services/authentication.dart';

import 'perguntas.dart';

class FormPage extends StatefulWidget {
  final Firestore firestore = new Firestore();
  FormPage({Key key}) : super(key: key);

  final String = "inicio";

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final BaseAuth auth = new Auth();

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  void _submit() async {
    _fbKey.currentState.save();
    if (_fbKey.currentState.validate()) {
      var save = _fbKey.currentState.value;
      String userId = "";
      userId = await auth.signUp(
          save.values.toList().elementAt(6), save.values.toList().elementAt(7));
      auth.sendEmailVerification();

      _fbKey.currentState.value.remove("senha");

      Firestore.instance.collection('cadastro').add(_fbKey.currentState.value);

      print('Criado usuario: $userId');

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Formulario(
                estado: save.values.toList().elementAt(3),
                idade: save.values.toList().elementAt(1))),
      );
    }
  }

/*
  _submit() {
    _fbKey.currentState.save();
    if (_fbKey.currentState.validate()) {
      var save = _fbKey.currentState.value;

      print(save.values.toList().elementAt(6));
      print(save.values.toList().elementAt(7));
    }
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Criar conta"),
      ),
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: FormBuilder(
              key: _fbKey,
              autovalidate: true,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: FormBuilderTextField(
                                attribute: "Apelido",
                                decoration:
                                    InputDecoration(labelText: "Apelido"),
                              ),
                            )
                            //container
                          ],
                        ),
                      ),
                      Flexible(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: FormBuilderTextField(
                                attribute: "Idade",
                                decoration: InputDecoration(
                                    labelText: "Informe sua Idade"),
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: false),
                                valueTransformer: (text) => num.tryParse(text),
                                validators: [
                                  FormBuilderValidators.numeric(),
                                  FormBuilderValidators.max(110),
                                ],
                              ),
                              //container
                            )
                          ],
                        ),
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: FormBuilderDropdown(
                                attribute: "gender",
                                decoration: InputDecoration(labelText: "Sexo:"),
                                hint: Text('Informe seu sexo'),
                                validators: [FormBuilderValidators.required()],
                                items: ['Masculino', 'Feminino']
                                    .map((gender) => DropdownMenuItem(
                                        value: gender, child: Text("$gender")))
                                    .toList(),
                              ),
                            )
                            //container
                          ],
                        ),
                      ),
                      Flexible(
                          child: Column(
                        children: <Widget>[
                          Container(
                            child: FormBuilderDropdown(
                              attribute: "estado",
                              decoration: InputDecoration(labelText: "Estado"),
                              // initialValue: 'Male',
                              hint: Text('Informe seu Estado'),
                              validators: [
                                FormBuilderValidators.required(
                                    errorText: "Gentiliza escolher a opcão")
                              ],
                              items: [
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
                              ]
                                  .map((grade) => DropdownMenuItem(
                                      value: grade, child: Text("$grade")))
                                  .toList(),
                            ),
                          )
                          //container
                        ],
                      ))
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),

                  FormBuilderDropdown(
                    attribute: "grade",
                    decoration: InputDecoration(labelText: "Escolaridade"),
                    hint: Text('Informe sua escolaridade'),
                    validators: [
                      FormBuilderValidators.required(
                          errorText: "Gentiliza escolher a opcão")
                    ],
                    items: [
                      "Fundamental Incompleto",
                      "Fundamental Completo",
                      "Médio Completo",
                      "Médio Incompleto",
                      "Superior Completo",
                      "Superior Incompleto",
                      "Pós-Graduação"
                    ]
                        .map((grade) => DropdownMenuItem(
                            value: grade, child: Text("$grade")))
                        .toList(),
                  ),

                  //estado

                  //renda
                  FormBuilderDropdown(
                    attribute: "renda",
                    decoration: InputDecoration(labelText: "Renda"),
                    hint: Text('Informe sua renda'),
                    validators: [
                      FormBuilderValidators.required(
                          errorText: "Gentiliza escolher a opcão")
                    ],
                    items: [
                      "até um salário minimo",
                      "Até três salarios minimos",
                      "Até cinco salarios minimos",
                      "Superior a cinco salarios minimos ",
                    ]
                        .map((renda) => DropdownMenuItem(
                            value: renda, child: Text("$renda")))
                        .toList(),
                  ),

                  FormBuilderTextField(
                    attribute: "email",
                    decoration: InputDecoration(
                      labelText: "E-mail",
                      hintText: 'Informe o seu E-mail',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validators: [
                      FormBuilderValidators.email(
                          errorText: "Necessário informar E-mail valido.")
                    ],
                  ),

                  FormBuilderTextField(
                    obscureText: true,
                    attribute: "senha",
                    decoration: InputDecoration(labelText: "Senha"),
                    validators: [
                      FormBuilderValidators.required(
                          errorText: "A senha não deve ser vazia"),
                      FormBuilderValidators.minLength(6,
                          errorText: "A senha devera ter no minimo 6 letras")
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20.0, top: 100.0, right: 20.0),
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.blue,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                onPressed: () {
                  _submit();
                },
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
    );
  }
}
