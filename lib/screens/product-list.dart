import 'package:flutter/material.dart';
import '../models/product.dart';
import 'product-add-edit.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = [
    Product(name: 'Produto 1', cost: 10.0, date: '01/01/2024', stock: 20),
    Product(name: 'Produto 2', cost: 20.0, date: '02/01/2024', stock: 15),
    // Adicione mais produtos conforme necessário
  ];

  void _addOrEditProduct({Product? product, required bool isEditing}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditProductScreen(
          product: product,
          isEditing: isEditing,
        ),
      ),
    );

    if (result != null && result is Product) {
      setState(() {
        if (isEditing) {
          int index = products.indexOf(product!);
          products[index] = result;
        } else {
          products.add(result);
        }
      });
    }
  }

  void _deleteProduct(Product product) {
    setState(() {
      products.remove(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('Custo: \$${product.cost} | Data: ${product.date} | Estoque: ${product.stock}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _addOrEditProduct(product: product, isEditing: true),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteProduct(product),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditProduct(isEditing: false),
        child: Icon(Icons.add),
        tooltip: 'Adicionar Produto',
      ),
    );
  }
}
