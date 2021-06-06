import 'package:flutter/material.dart';
import 'package:flutter_app/providers/auth.dart';
import 'package:flutter_app/screens/auth_screen.dart';
import 'package:flutter_app/screens/orders_screen.dart';
import 'package:flutter_app/screens/product_overview_screen.dart';
import 'package:flutter_app/screens/user_products_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('TBIB Shop'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () => Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.size,
                  duration: Duration(milliseconds: 500),
                  alignment: Alignment.center,
                  child: ProductOverviewScreen()),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () => Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.size,
                  duration: Duration(milliseconds: 500),
                  alignment: Alignment.center,
                  child: OrdersScreen()),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Product'),
            onTap: () => Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.size,
                  duration: Duration(milliseconds: 500),
                  alignment: Alignment.center,
                  child: UsersProductsScreen()),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              context.read<Auth>().logout();
              Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.size,
                    duration: Duration(milliseconds: 500),
                    alignment: Alignment.center,
                    child: AuthScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
