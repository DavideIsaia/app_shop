// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart' show Cart; 
// così non importa CartItem e non va in conflitto con cart_item
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrello'),
      ),
      body: Column(children: [
        Card(
          margin: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Totale',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(width: 10),
              Spacer(),
              Chip(
                label: Text(
                  '€ ${cart.totalAmount}',
                  style: TextStyle(
                      color:
                          Theme.of(context).primaryTextTheme.titleLarge.color),
                ),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              TextButton(
                onPressed: () {},
                child: Text('ORDINA ADESSO'),
              )
            ],
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => CartItem(
                    cart.items.values.toList()[i].id,
                    cart.items.values.toList()[i].price,
                    cart.items.values.toList()[i].quantity,
                    cart.items.values.toList()[i].title,
                  ),
                ),
        ),
      ]),
    );
  }
}
