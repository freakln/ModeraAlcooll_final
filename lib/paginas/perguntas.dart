import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import "package:transformer_page_view/transformer_page_view.dart";

class Formulario extends StatefulWidget {
  Formulario({Key key, this.estado, this.idade}) : super(key: key);
  final estado;
  final idade;

  @override
  _FormularioState createState() => new _FormularioState();
}

class RadioGroup extends StatefulWidget {
  final List<String> titles;

  final ValueChanged<int> onIndexChanged;

  const RadioGroup({Key key, this.titles, this.onIndexChanged})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _RadioGroupState();
  }
}

class _RadioGroupState extends State<RadioGroup> {
  int _index = 1;

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    for (int i = 0; i < widget.titles.length; ++i) {
      list.add(((String title, int index) {
        return new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Radio<int>(
                value: index,
                groupValue: _index,
                onChanged: (int index) {
                  setState(() {
                    _index = index;
                    widget.onIndexChanged(_index);
                  });
                }),
            new Text(title)
          ],
        );
      })(widget.titles[i], i));
    }

    return new Wrap(
      children: list,
    );
  }
}

class _FormularioState extends State<Formulario> {
  final GlobalKey<FormBuilderState> _formeKey = GlobalKey<FormBuilderState>();
  var save;
  int _index = 1;
  List<int> _respostas = new List();
  double size = 20.0;
  double activeSize = 30.0;

  PageController controller;

  PageIndicatorLayout layout = PageIndicatorLayout.WARM;

  bool loop = false;

  int _currVal = 4;

  informaResultado(List<int> resposta, double questao3) {
    print(questao3);
    int soma = resposta.elementAt(0) +
        resposta.elementAt(1) +
        resposta.elementAt(5) +
        resposta.elementAt(6);
    print(soma);
    if (soma == 4) {
      if (questao3 < 50) {
        return 2;
      } else if (questao3 > 50 && questao3 < 100) {
        return 3;
      } else if (questao3 > 100) {
        return 1;
      }
    } else if (soma == 0) {
      if (questao3 < 40) {
        return 2;
      } else if (questao3 < 100) {
        return 3;
      } else
        return 1;
    } else if (questao3 == 0) return 4;

    return 4;
  }

  List<GroupModel> _group = [
    GroupModel(
      text: " Cerveja (1 lata 355mL ou 1 long neck), chope (1 copo – 350mL)",
      index: 1,
    ),
    GroupModel(
      text: "Cerveja (1 garrafa – 600mL)",
      index: 2,
    ),
    GroupModel(
      text: "Uísque, pinga, vodka, cachaça (1 dose – 25mL)",
      index: 3,
    ),
    GroupModel(
      text: "Vinho do porto, licor (1 dose – 50mL)",
      index: 4,
    ),
    GroupModel(
      text: "Vinho de mesa, Champagne (1 dose – 75mL)",
      index: 5,
    ),
  ];

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller = new PageController();
    super.initState();
  }

  @override
  void didUpdateWidget(Formulario oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void _handleRadioValueChange2(int value) => setState(() {
        _currVal = value;
      });

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
          onPressed: () {
            _respostas.add(1);
            print("teste: " + widget.estado);
            print("teste: " + widget.idade.toString());
            controller.nextPage(
                duration: Duration(milliseconds: 400), curve: Curves.linear);
          },
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

  Widget botaoNao(String text) {
    return SizedBox(
      width: 150,
      height: 50,
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(40.0),
        color: Colors.blue,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            _respostas.add(0);
            controller.nextPage(
                duration: Duration(milliseconds: 400), curve: Curves.linear);
          },
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

  Widget botaoCustom(String text) {
    return SizedBox(
      width: 150,
      height: 50,
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(40.0),
        color: Colors.blue,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            _respostas.add(0);
            controller.nextPage(
                duration: Duration(milliseconds: 400), curve: Curves.linear);
          },
          child: Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget botaoFinal(String text) {
    return SizedBox(
      width: 150,
      height: 50,
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(40.0),
        color: Colors.blue,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            if (text == "Culpa")
              _respostas.add(0);
            else
              _respostas.add(1);

            var calcValor = 0.0;

            for (var i = 0; i < 5; i++) {
              calcValor = 0.583 *
                  double.parse(myController.text) *
                  int.parse(save.values.toList().elementAt(i).toString());
            }

            var jsonRespostas = {
              "idade": widget.idade.toString(),
              "estado": widget.estado.toString(),
              "pergunta_1": _respostas.elementAt(0) == 1 ? "sim" : "nao",
              "pergunta_2": _respostas.elementAt(0) == 1 ? "sim" : "nao",
              "pergunta_3": {
                "peso": double.parse(myController.text),
                "bebida-1": save.values.toList().elementAt(0).toString(),
                "bebida-2": save.values.toList().elementAt(1).toString(),
                "bebida-3": save.values.toList().elementAt(2).toString(),
                "bebida-4": save.values.toList().elementAt(3).toString(),
                "bebida-5": save.values.toList().elementAt(4).toString()
              },
              "pergunta_4": _respostas.elementAt(0) == 1 ? "sim" : "nao",
              "pergunta_5": _respostas.elementAt(0) == 1 ? "sim" : "nao",
              "pergunta_6": _respostas.elementAt(0) == 1 ? "sim" : "nao",
              "pergunta_7": _respostas.elementAt(0) == 1 ? "sim" : "nao",
            };

            print(informaResultado(_respostas, calcValor));
            print(jsonRespostas);

            Firestore.instance.collection('usuario').add(jsonRespostas);

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FinalScreen(
                      text:
                          informaResultado(_respostas, calcValor).toString())),
            );
          },
          child: Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      //questao 1
      Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: RichText(
                    text: TextSpan(
                      text: 'Alguém já lhe disse que  você bebe muito?',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Raleway',
                          fontSize: 60.0),
                    ),
                  ),
                ),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[botaosim("Sim"), botaoNao("Não")],
              ),
            ],
          ),
        ),
      ),
      //questao 2
      Container(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Você já pensou em parar de beber?',
                          style: TextStyle(color: Colors.black, fontSize: 60),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[botaosim("Sim"), botaoNao("Não")],
                ),
              ]),
        ),
      ),
      //questao 3
      Container(
        child: Padding(
          padding: const EdgeInsets.all(
            15.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "Quanto você bebe em uma hora, por exemplo, quando vai a uma festa ou sai com os amigos ou mesmo quando está sozinho?",
                style: TextStyle(fontSize: 25),
              ),
              Row(
                children: <Widget>[
                  Text(
                    "Informe seu peso:",
                    style: TextStyle(fontSize: 25),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: SizedBox(
                      width: 200,
                      height: 50,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Peso',
                        ),
                        style: TextStyle(fontSize: 20),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        controller: myController,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  height: 300.0,
                  child: FormBuilder(
                    key: _formeKey,
                    autovalidate: false,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                  width: 50,
                                  height: 50,
                                  child: FormBuilderTextField(
                                    attribute: "bebida-1",
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: false),
                                  ),
                                )
                                //container
                              ],
                            ),
                            Flexible(
                              child: Container(
                                  child: Text(
                                " Cerveja (1 lata 355mL ou 1 long neck), chope (1 copo – 350mL)",
                                style: TextStyle(fontSize: 14),
                              )
                                  //container
                                  ),
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.start,
                        ),
                        Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                  width: 50,
                                  height: 50,
                                  child: FormBuilderTextField(
                                    attribute: "bebida-2",
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: false),
                                  ),
                                )
                                //container
                              ],
                            ),
                            Flexible(
                              child: Container(
                                  child: Text(
                                "Cerveja (1 garrafa – 600mL)",
                                style: TextStyle(fontSize: 14),
                              )
                                  //container
                                  ),
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.start,
                        ),
                        Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                  width: 50,
                                  height: 50,
                                  child: FormBuilderTextField(
                                    attribute: "bebida-3",
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: false),
                                  ),
                                )
                                //container
                              ],
                            ),
                            Flexible(
                              child: Container(
                                  child: Text(
                                "Uísque, pinga, vodka, cachaça (1 dose – 25mL)",
                                style: TextStyle(fontSize: 14),
                              )
                                  //container
                                  ),
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.start,
                        ),
                        Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                  width: 50,
                                  height: 50,
                                  child: FormBuilderTextField(
                                    attribute: "bebida-4",
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: false),
                                  ),
                                )
                                //container
                              ],
                            ),
                            Flexible(
                              child: Container(
                                  child: Text(
                                "Vinho do porto, licor (1 dose – 50mL)",
                                style: TextStyle(fontSize: 14),
                              )
                                  //container
                                  ),
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.start,
                        ),
                        Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                  width: 50,
                                  height: 50,
                                  child: FormBuilderTextField(
                                    attribute: "bebida-5",
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: false),
                                  ),
                                )
                                //container
                              ],
                            ),
                            Flexible(
                              child: Container(
                                  child: Text(
                                "Vinho de mesa, Champagne (1 dose – 75mL)",
                                style: TextStyle(fontSize: 14),
                              )
                                  //container
                                  ),
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.start,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(40.0),
                    color: Colors.blue,
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      onPressed: () {
                        _formeKey.currentState.save();
                        if (_formeKey.currentState.validate()) {
                          print(_formeKey.currentState.value);
                        }

                        save = _formeKey.currentState.value;
                        controller.nextPage(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.linear);
                      },
                      child: Text("Confirma",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      //questao 4
      Container(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Você acha que bebe muito?',
                          style: TextStyle(color: Colors.black, fontSize: 60),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[botaosim("Sim"), botaoNao("Não")],
                ),
              ]),
        ),
      ),
      //questao 5
      Container(
        child: Center(
          child: Column(
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
                        'Você costuma beber água enquanto consome bebida alcoólica?',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Raleway',
                        fontSize: 50.0),
                  ),
                ),
              ))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[botaosim("Sim"), botaoNao("não")],
              ),
            ],
          ),
        ),
      ),
      //questao 6
      Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  constraints: BoxConstraints.expand(
                    height: 400.0,
                  ),
                  child: Center(
                      child: Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: RichText(
                      text: TextSpan(
                        text:
                            'Eventos sociais (festa, reunião com amigos, encontro familiar etc) são mais legais se'
                            'tiverem bebidas alcoólicas?',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Raleway',
                            fontSize: 48.0),
                      ),
                    ),
                  ))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[botaosim("Sim"), botaoNao("Não")],
              ),
            ],
          ),
        ),
      ),
      //questao 7
      Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  constraints: BoxConstraints.expand(
                    height: 260.0,
                  ),
                  child: Center(
                      child: Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: RichText(
                      text: TextSpan(
                        text: 'Você se sente mais à vontade quando bebe?',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Raleway',
                            fontSize: 60.0),
                      ),
                    ),
                  ))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[botaosim("Sim"), botaoNao("Não")],
              ),
            ],
          ),
        ),
      ),
      //questao 8
      Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  constraints: BoxConstraints.expand(
                    height: 260.0,
                  ),
                  child: Center(
                      child: Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: RichText(
                      text: TextSpan(
                        text: 'Após beber você fica com a sensação de:',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Raleway',
                            fontSize: 50.0),
                      ),
                    ),
                  ))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  botaoFinal("bem-estar"),
                  botaoFinal("Culpa")
                ],
              ),
            ],
          ),
        ),
      ),
      new Container(
        color: Colors.amberAccent,
      ),
      new Container(
        color: Colors.lime,
      )
    ];
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Questinário"),
        ),
        resizeToAvoidBottomPadding: false,
        body: new Column(
          children: <Widget>[
            new Expanded(
                child: new Stack(
              children: <Widget>[
                loop
                    ? new TransformerPageView.children(
                        physics: new NeverScrollableScrollPhysics(),
                        children: children,
                        pageController: controller,
                      )
                    : new PageView(
                        controller: controller,
                        children: children,
                        physics: new NeverScrollableScrollPhysics(),
                      ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        color: Colors.grey[800].withOpacity(0.5),
                        height: 50,
                        child: new Align(
                          alignment: Alignment.bottomCenter,
                          child: new Padding(
                            padding: new EdgeInsets.only(bottom: 15.0),
                            child: new PageIndicator(
                              layout: layout,
                              size: size,
                              activeSize: activeSize,
                              controller: controller,
                              space: 10.0,
                              count: 9,
                              color: Colors.deepPurple,
                            ),
                          ),
                        )))
              ],
            ))
          ],
        ));
  }
}

class FinalScreen extends StatefulWidget {
  final String text;

  FinalScreen({Key key, @required this.text}) : super(key: key);

  @override
  _FinalScreenState createState() => _FinalScreenState();
}

class _FinalScreenState extends State<FinalScreen> {
  var frases = [
    "Seu consumo de álcool está muito alto e você corre o risco de desencadear doenças físicas e mentais no seu organismo!",
    "Seu consumo de álcool não está tão alto, mas se mantê-lo por mais tempo pode aparecer problemas de saúde!",
    "você está bebendo álcool dentro dos limites!",
    "zero consumo de álcool!"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Text(
          frases[int.parse(widget.text) - 1],
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}

class GroupModel {
  String text;
  int index;
  GroupModel({this.text, this.index});
}
