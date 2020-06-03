class Usuario {
  String id;
  String nome;
  String isAdmin;
  String empresa;
  String user;
  String token;

  Usuario(
      {this.id, this.nome, this.isAdmin, this.empresa, this.user, this.token});

  Usuario.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    isAdmin = json['isAdmin'];
    empresa = json['empresa'];
    user = json['user'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['isAdmin'] = this.isAdmin;
    data['empresa'] = this.empresa;
    data['user'] = this.user;
    data['token'] = this.token;
    return data;
  }

  String toString(){
    return 'Usuario(nome: $nome, token: $token)';
  }
}