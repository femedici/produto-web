import 'package:flutter/material.dart';
import '../models/product.dart';

class AddEditProductScreen extends StatefulWidget {
  final Product? product;
  final bool isEditing;

  AddEditProductScreen({this.product, required this.isEditing});

  @override
  _AddEditProductScreenState createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late double _cost;
  late String _date;
  late int _stock;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.product != null) {
      _name = widget.product!.name;
      _cost = widget.product!.cost;
      _date = widget.product!.date;
      _stock = widget.product!.stock;
    } else {
      _name = '';
      _cost = 0.0;
      _date = '';
      _stock = 0;
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final product = Product(
        name: _name,
        cost: _cost,
        date: _date,
        stock: _stock,
      );
      Navigator.of(context).pop(product);
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
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Nome do Produto'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do produto';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: _cost.toString(),
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
                onSaved: (value) => _cost = double.parse(value!),
              ),
              TextFormField(
                initialValue: _date,
                decoration: InputDecoration(labelText: 'Data'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a data';
                  }
                  return null;
                },
                onSaved: (value) => _date = value!,
              ),
              TextFormField(
                initialValue: _stock.toString(),
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
                onSaved: (value) => _stock = int.parse(value!),
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
