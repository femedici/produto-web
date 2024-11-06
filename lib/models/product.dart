class Product {
  final int id;
  final String descricao;
  final double preco;
  final int estoque;
  final String data;

  Product({
    required this.id,
    required this.descricao,
    required this.preco,
    required this.estoque,
    required this.data,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      descricao: json['descricao'] ?? '',
      preco: json['preco'] is String ? double.tryParse(json['preco']) ?? 0.0 : (json['preco'] ?? 0).toDouble(),
      estoque: json['estoque'] ?? 0,
      data: json['data'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'descricao': descricao,
      'preco': preco,
      'estoque': estoque,
      'data': data,
    };
  }
}
