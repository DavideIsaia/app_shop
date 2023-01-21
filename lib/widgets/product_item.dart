import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  // final String description;
  // final double price;
  final String imageUrl;
  // bool isFavorite;

  ProductItem(
    this.id,
    this.title,
    // this.description,
    // this.price,
    this.imageUrl,
    // this.isFavorite,
  );

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        backgroundColor: Colors.black54,
        leading: IconButton(
          icon: Icon(Icons.favorite),
          onPressed: () {},
        ),
        title: Text(
          title,
          textAlign: TextAlign.center,
        ),
        trailing: IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () {},
        ),
      ),
    );
  }
}
