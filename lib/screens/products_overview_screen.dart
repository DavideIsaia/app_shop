import 'package:app_shop/providers/product.dart';
import 'package:app_shop/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/products_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showFavoritesOnly = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('David Shop'),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favorites) {
                    _showFavoritesOnly = true;
                  } else {
                    _showFavoritesOnly = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Mostra i preferiti'),
                      value: FilterOptions.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text('Mostra tutto'),
                      value: FilterOptions.All,
                    ),
                  ]),
        ],
      ),
      body: ProductsGrid(_showFavoritesOnly),
    );
  }
}
