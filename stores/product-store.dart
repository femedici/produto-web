mport 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductStore {
  final String apiUrl =
      'http://localhost:3000';

  Future<List<Product>> fetchProducts() async {
  final response = await http.get(Uri.parse('$apiUrl/produtos'));
    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Product.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }


  Future<Product> fetchProductById(String id) async {
    final response = await http.get(Uri.parse('$apiUrl/produto/$id'));
    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<void> deleteProduct(String id) async {
    final response = await http.delete(Uri.parse('$apiUrl/produtos/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$apiUrl/produto'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add product');
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    final response = await http.put(
      Uri.parse('$apiUrl/produto/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update product');
    }
  }
}