class Especie {
  String id;
  String nome;

  Especie(
      {this.id,
        this.nome});

  factory Especie.fromJson(Map<String, dynamic> json) {
    return Especie(
        id: json["id"],
        nome: json["nome"]);
  }
}