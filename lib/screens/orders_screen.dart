import 'package:flutter/material.dart';
import 'package:flutter_app/providers/orders.dart' show Orders;
import 'package:flutter_app/widgets/app_drawer.dart';
import 'package:flutter_app/widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: context.read<Orders>().fetchAndSetOrders(),
        builder: (ctx, AsyncSnapshot snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapShot.error != null) {
              return Center(
                child: Text("An error Occurred!"),
              );
            }

            if (!snapShot.hasData) {
              return Center(
                child: Text(
                  'Please Order Now',
                  style: Theme.of(context).primaryTextTheme.headline6,
                ),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, _) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
