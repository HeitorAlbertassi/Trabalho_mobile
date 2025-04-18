class Produto {
  String id;
  String nome;
  String unidade;
  int qtdEstoque;
  double precoVenda;
  int status;
  double? custo;
  String? codigoBarra;

  Produto({
    required this.id,
    required this.nome,
    required this.unidade,
    required this.qtdEstoque,
    required this.precoVenda,
    required this.status,
    this.custo,
    this.codigoBarra,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'unidade': unidade,
      'qtdEstoque': qtdEstoque,
      'precoVenda': precoVenda,
      'status': status,
      'custo': custo,
      'codigoBarra': codigoBarra,
    };
  }

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      nome: json['nome'],
      unidade: json['unidade'],
      qtdEstoque: json['qtdEstoque'],
      precoVenda: json['precoVenda'],
      status: json['status'],
      custo: custo,
      codigoBarra: codigoBarra,
    );
  }
}