import 'package:flutter/material.dart';
import '../models/product.dart';
import '../stores/product-store.dart';
import '../screens/product-add-edit.dart';

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
    final fetchedProducts = await _productStore.fetchProducts();
    setState(() {
      products = fetchedProducts;
    });
  }

  void _openProductModal({Product? product, required bool isEditing}) async {
    final result = await showDialog<Product>(
      context: context,
      builder: (context) => AddEditProductScreen(product: product, isEditing: isEditing),
    );

    if (result != null) {
      _fetchProducts(); 
    }
  }

  Future<void> _confirmDeleteProduct(Product product) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmação'),
        content: Text('Deseja excluir o produto "${product.descricao}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _deleteProduct(product);
    }
  }

  Future<void> _deleteProduct(Product product) async {
    try {
      await _productStore.deleteProduct(product.id);
      
      setState(() {
        products.remove(product);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produto excluído com sucesso')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir produto: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              '../images/UTFPR_logo.png', 
              width: 90,
              height: 60, 
            ),
            const SizedBox(width: 30),
            const Text(
              'API de Produtos',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
            color: Colors.black), 
        elevation: 4.0, 
        shadowColor: Colors.grey.withOpacity(0.5),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Lista de Produtos',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: products.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _openProductModal(product: product, isEditing: true),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.descricao,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text('Preço: \$${product.preco}', style: TextStyle(fontSize: 16)),
                          Text('Data: ${product.data.substring(0, 10)}', style: TextStyle(fontSize: 16)),
                          Text('Estoque: ${product.estoque} unidades', style: TextStyle(fontSize: 16)),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(Icons.delete, color: Colors.black),
                              onPressed: () => _confirmDeleteProduct(product),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openProductModal(isEditing: false),
        icon: Icon(Icons.add),
        label: Text(
          'Adicionar Produto',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber[400],
        tooltip: 'Adicionar Produto',
      ),
    );
  }
}