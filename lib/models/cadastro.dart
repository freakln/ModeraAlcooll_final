class Cadastro {
  String login;
  DateTime data;
  double renda;
  String email = '';
  String escolaridade;
  String estado;
  String genero;

  Cadastro();

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map['login'] = login.toString();
    map['data'] = data.toString();
    map['renda'] = renda.toString();
    map['email'] = email.toString();

    return map;
  }

  Cadastro.fromMap(Map<String, dynamic> map) {
    this.login = map['login'];
    this.data = map['data'];
    this.renda = map['renda'];
    this.email = map['email'];
  }
}
