class Chamados {
  String id;
  String numero;
  String local;
  String rota;
  String detalhes;
  String dataIni;
  String slaatendimento;
  String slaconclusao;
  String subcategoria;
  String diasAberto;

  Chamados(
      {this.id,
      this.numero,
      this.local,
      this.rota,
      this.detalhes,
      this.dataIni,
      this.slaatendimento,
      this.slaconclusao,
      this.subcategoria,
      this.diasAberto});

  Chamados.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    numero = json['numero'];
    local = json['local'];
    rota = json['rota'];
    detalhes = json['detalhes'];
    dataIni = json['data_ini'];
    slaatendimento = json['slaatendimento'];
    slaconclusao = json['slaconclusao'];
    subcategoria = json['subcategoria'];
    diasAberto = json['dias_aberto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['numero'] = this.numero;
    data['local'] = this.local;
    data['rota'] = this.rota;
    data['detalhes'] = this.detalhes;
    data['data_ini'] = this.dataIni;
    data['slaatendimento'] = this.slaatendimento;
    data['slaconclusao'] = this.slaconclusao;
    data['subcategoria'] = this.subcategoria;
    data['dias_aberto'] = this.diasAberto;
    return data;
  }
}