// ignore_for_file: prefer_const_constructors, missing_return

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  // var _isLoading = false;

  //metodi alternativi con statefulwidget
  // @override
  // void initState() {
  //   Future.delayed(Duration.zero).then((_) async {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  //   super.initState();
  // }

  // @override
  // void initState() {
  //   _isLoading = true;
  //   Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((_) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // con questo metodo darebbe loop infinito, quindi uso un Consumer
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('I tuoi ordini'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future:
                Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.error != null) {
                  return Center(child: Text('Errore!'));
                } else {
                  return Consumer<Orders>(
                      builder: (ctx, orderData, child) => ListView.builder(
                            itemCount: orderData.orders.length,
                            itemBuilder: ((ctx, i) =>
                                OrderItem(orderData.orders[i])),
                          ));
                }
              }
            })));
  }
}
