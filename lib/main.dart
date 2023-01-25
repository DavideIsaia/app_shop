import 'package:app_shop/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import 'package:app_shop/providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './providers/auth.dart';
import './screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // solo il widget col notifier provider viene ricostruito quando qualcosa cambia nei dati, e non l'intera app
    return MultiProvider(
        // con multiprovider nel main, tutto ciò che è all'interno viene reso visibile a tutta l'app
        providers: [
          // create e update(con proxy) se versione provider > 3, altrimenti builder
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            // create: (ctx) => Products(),
            update: (ctx, auth, previousProducts) => Products(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.items),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (ctx, auth, previousOrders) => Orders(
                auth.token,
                auth.userId,
                previousOrders == null ? [] : previousOrders.orders),
          ),
          // ChangeNotifierProvider(
          //   create: (ctx) => Orders(),
          // ),
        ],
        child: Consumer<Auth>(
          builder: (context, authValue, _) => MaterialApp(
            title: "David's Shop",
            theme: ThemeData(
              primarySwatch: Colors.blue,
              accentColor: Colors.amber,
              fontFamily: 'Lato',
            ),
            // se l'user è già autorizzato allora mostra la schermata prodotti, altrimenti la login screen
            home: authValue.isAuth ? ProductsOverviewScreen() : AuthScreen(),
            routes: {
              AuthScreen.routeName: (context) => AuthScreen(),
              ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
              CartScreen.routeName: (context) => CartScreen(),
              OrdersScreen.routeName: (context) => OrdersScreen(),
              UserProductsScreen.routeName: (context) => UserProductsScreen(),
              EditProductScreen.routeName: (context) => EditProductScreen(),
            },
          ),
        ));
  }
}
