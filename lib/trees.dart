class Trees {
  String id;
  String nome;
  String nascimento;
  String especie;

  Trees(
      {this.id,
        this.nome,
        this.nascimento,
        this.especie});

  factory Trees.fromJson(Map<String, dynamic> json) {
    return Trees(
        id: json["id"],
        nome: json["nome"],
        nascimento: json["nascimento"],
        especie: json["especie"]);
  }
}