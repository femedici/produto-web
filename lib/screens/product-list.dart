import 'package:flutter/material.dart';
import '../models/product.dart';
import 'product-add-edit.dart';
import '../stores/product-store.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductStore _productStore = ProductStore();
  List<Product> products = [];

  void _addOrEditProduct({Product? product, required bool isEditing}) async {
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
        title: Row(
          children: [
            Image.asset(
              '../images/UTFPR_logo.png', // Caminho da imagem local na pasta assets
              width: 90, // Largura da imagem
              height: 60, // Altura da imagem
            ),
            const SizedBox(width: 30), // Espaço entre a imagem e o texto
            const Text(
              'API de Produtos',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
            color: Colors.black), // Define a cor dos ícones como preto
        elevation: 4.0, // Altura da sombra
        shadowColor: Colors.grey.withOpacity(0.5), // Cor da sombra
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
          ),
          Expanded(
            child: ListView.separated(
              itemCount: products.length,
              separatorBuilder: (context, index) => const Divider(), // Divider entre os cards
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text('Custo: \$${product.cost}'),
                        Text('Data: ${product.date}'),
                        Text('Estoque: ${product.stock} unidades'),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.black),
                              onPressed: () => _addOrEditProduct(
                                  product: product, isEditing: true),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.black),
                              onPressed: () => _deleteProduct(product),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addOrEditProduct(isEditing: false),
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
