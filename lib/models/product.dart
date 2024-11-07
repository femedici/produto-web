class Product {
  final int id;
  final String descricao;  
  final String preco;
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
      id: json['id'] ?? 0,  // Se 'id' for null, atribui 0
      descricao: json['descricao'] ?? '',  // Se 'descricao' for null, atribui uma string vazia
      preco: json['preco'] ?? '0',  // Se 'preco' for null, atribui '0'
      estoque: json['estoque'] ?? 0,  // Se 'estoque' for null, atribui 0
      data: json['data'] ?? '',  // Se 'data' for null, atribui uma string vazia
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricao': descricao,
      'preco': preco,
      'estoque': estoque,
      'data': data,
    };
  }
}