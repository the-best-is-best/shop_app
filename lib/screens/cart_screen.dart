import 'package:flutter/material.dart';
import 'package:flutter_app/providers/cart.dart' show Cart;
import 'package:flutter_app/providers/orders.dart';
import 'package:flutter_app/providers/product.dart';
import 'package:flutter_app/providers/products.dart';
import 'package:flutter_app/widgets/cart_item.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Cart>();
    final products = context.read<Products>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$  ${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .color),
                    ),
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) {
                String image;
                for (Product product in products.items) {
                  if (product.id == cart.items.keys.toList()[i]) {
                    image = product.imageUrl;
                    break;
                  }
                }
                return CartItem(
                  cart.items.values.toList()[i].id,
                  cart.items.keys.toList()[i],
                  image,
                  cart.items.values.toList()[i].price,
                  cart.items.values.toList()[i].quantity,
                  cart.items.values.toList()[i].title,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final Cart cart;

  const OrderButton({
    @required this.cart,
  });

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: _isLoading ? CircularProgressIndicator() : Text("Order Now"),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });

              await context.read<Orders>().addOrder(
                    widget.cart.items.values.toList(),
                    widget.cart.totalAmount,
                  );

              setState(() {
                _isLoading = false;
              });
              widget.cart.clear();
            },
    );
  }
}
