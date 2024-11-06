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
  // Exibe o AlertDialog para confirmar a exclusão
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirmar Exclusão'),
        content: Text('Você tem certeza que deseja excluir este produto?'),
        actions: <Widget>[
          // Botão "Cancelar"
          OutlinedButton(
            onPressed: () {
              // Fecha o diálogo e não faz nada
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black, // Cor do texto do botão
            ),
          ),
          // Botão "Excluir"
          OutlinedButton(
            onPressed: () {
              // Fecha o diálogo e exclui o produto
              setState(() {
                products.remove(product);
              });
              Navigator.of(context).pop(); // Fecha o diálogo após a exclusão
            },
            child: Text('Excluir'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black, // Cor do texto do botão
            ),
          ),
        ],
      );
    },
  );
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título antes da listagem de produtos
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
        ],
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
