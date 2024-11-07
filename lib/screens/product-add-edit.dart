import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddEditProductScreen extends StatefulWidget {
  final Product? product;
  final bool isEditing;

  AddEditProductScreen({this.product, required this.isEditing});

  @override
  _AddEditProductScreenState createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _descricao;
  late double _preco;
  late String _data;
  late int _estoque;
  final String apiUrl ='http://localhost:3000';

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.product != null) {
      _descricao = widget.product!.descricao;
      _preco = widget.product!.preco;
      _data = widget.product!.data;
      _estoque = widget.product!.estoque;
    } else {
      _descricao = '';
      _preco = 0.0;
      _data = '';
      _estoque = 0;
    }
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validata()) {
      _formKey.currentState!.save();
      final product = Product(
        id: widget.product?.id ?? '',
        descricao: _descricao,
        preco: _preco,
        data: _data,
        estoque: _estoque,
      );
       try {
        if (widget.isEditing) {
          await _updataProduct(product);
        } else {
          await _addProduct(product);
        }
        Navigator.of(context).pop(product);
      } catch (error) {
        // Handle error (e.g., show a snackbar or dialog)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar o produto')),
        );
      }
    }
  }

  Future<void> _addProduct(Product product) async {
    final url = Uri.parse('$apiUrl/products');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Erro ao adicionar produto');
    }
  }

  Future<void> _updataProduct(Product product) async {
    final url = Uri.parse('$apiUrl//products/${product.id}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar produto');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Editar Produto' : 'Adicionar Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _descricao,
                decoration: InputDecoration(labelText: 'Nome do Produto'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do produto';
                  }
                  return null;
                },
                onSaved: (value) => _descricao = value!,
              ),
              TextFormField(
                initialValue: _preco.toString(),
                decoration: InputDecoration(labelText: 'Custo'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o custo';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor, insira um valor numérico';
                  }
                  return null;
                },
                onSaved: (value) => _preco = double.parse(value!),
              ),
              TextFormField(
                initialValue: _data,
                decoration: InputDecoration(labelText: 'Data'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a data';
                  }
                  return null;
                },
                onSaved: (value) => _data = value!,
              ),
              TextFormField(
                initialValue: _estoque.toString(),
                decoration: InputDecoration(labelText: 'Quantidade em Estoque'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a quantidade em estoque';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor, insira um número inteiro';
                  }
                  return null;
                },
                onSaved: (value) => _estoque = int.parse(value!),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text(widget.isEditing ? 'Salvar Alterações' : 'Adicionar Produto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
