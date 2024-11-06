import 'package:flutter/material.dart';
import '../models/product.dart';
import '../stores/product-store.dart';

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
  final ProductStore _productStore = ProductStore();

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
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final product = Product(
        id: widget.product?.id ?? 0,
        descricao: _descricao,
        preco: _preco,
        data: _data,
        estoque: _estoque,
      );

      try {
        if (widget.isEditing) {
          await _productStore.updateProduct(product);
        } else {
          await _productStore.addProduct(product);
        }
        Navigator.of(context).pop(product);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar o produto: $error')),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _data = pickedDate.toIso8601String(); // Formato de string ISO 8601
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEditing ? 'Editar Produto' : 'Adicionar Produto'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                initialValue: _descricao,
                decoration: InputDecoration(labelText: 'Nome do Produto'),
                validator: (value) => value == null || value.isEmpty ? 'Insira o nome' : null,
                onSaved: (value) => _descricao = value!,
              ),
              TextFormField(
                initialValue: _preco.toString(),
                decoration: InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.number,
                validator: (value) => double.tryParse(value!) == null ? 'Preço inválido' : null,
                onSaved: (value) => _preco = double.parse(value!),
              ),
              TextFormField(
                initialValue: _estoque.toString(),
                decoration: InputDecoration(labelText: 'Estoque'),
                keyboardType: TextInputType.number,
                validator: (value) => int.tryParse(value!) == null ? 'Estoque inválido' : null,
                onSaved: (value) => _estoque = int.parse(value!),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_data.isEmpty ? 'Selecione uma data' : 'Data: $_data'.substring(0, 16)),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _saveForm,
          child: Text('Salvar'),
        ),
      ],
    );
  }
}
