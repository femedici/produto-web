import 'package:flutter/material.dart';
import '../models/product.dart';
import '../stores/product-store.dart';
import 'product-add-edit.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductStore _productStore = ProductStore();
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final fetchedProducts = await _productStore.fetchProducts();
      setState(() {
        products = fetchedProducts;
      });
    } catch (error) {
      print('Error fetching products: $error');
    }
  }

  Future<void> _addOrEditProduct({Product? product, required bool isEditing}) async {
    // Lógica de adicionar/editar o produto utilizando a store
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
          // Lógica de atualização
        } else {
          _productStore.addProduct(result);
          products.add(result);
        }
      });
    }
  }

  void _deleteProduct(Product product) async {
    try {
      await _productStore.deleteProduct(product.id);
      setState(() {
        products.remove(product);
      });
    } catch (error) {
      print('Error deleting product: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API de Produtos'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('Custo: ${product.cost}, Estoque: ${product.stock}'),
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
      ),
    );
  }
}
