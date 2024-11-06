import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductStore {
  final String apiUrl = 'http://localhost:3000';

  Future<List<Product>> fetchProducts() async {
    final url = Uri.parse('$apiUrl/produtos');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        print('Erro ao carregar produtos. Código: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Erro ao conectar-se ao backend: $e');
      return [];
    }
  }

  Future<Product?> fetchProductById(int id) async {
    final url = Uri.parse('$apiUrl/produto/$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Product.fromJson(data);
    } else {
      print('Erro ao buscar produto. Código: ${response.statusCode}');
      return null;
    }
  }

   Future<void> addProduct(Product product) async {
    final url = Uri.parse('$apiUrl/produto');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );

    if (response.statusCode != 201) {
      print('Erro ao criar produto! Código: ${response.statusCode}');
      print('Resposta: ${response.body}');
    } else {
      print('Produto criado com sucesso!');
    }
  }

  Future<void> updateProduct(Product product) async {
    final url = Uri.parse('$apiUrl/produto/${product.id}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar produto');
    }
  }

  Future<void> deleteProduct(int id) async {
    final url = Uri.parse('$apiUrl/produto/$id');
    final response = await http.delete(url);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Erro ao excluir produto');
    }
  }
}
