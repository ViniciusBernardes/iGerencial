class Boletos {
  String id;
  String rota;
  String tipo;
  String descricao;
  String data;
  String valor;
  String linha;

  Boletos(
      {this.id,
      this.rota,
      this.tipo,
      this.descricao,
      this.data,
      this.valor,
      this.linha});

  Boletos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rota = json['rota'];
    tipo = json['tipo'];
    descricao = json['descricao'];
    data = json['data'];
    valor = json['valor'];
    linha = json['linha'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rota'] = this.rota;
    data['tipo'] = this.tipo;
    data['descricao'] = this.descricao;
    data['data'] = this.data;
    data['valor'] = this.valor;
    data['linha'] = this.linha;
    return data;
  }
}