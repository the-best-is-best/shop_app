import 'package:flutter/material.dart';
import 'package:flutter_app/providers/cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String imageUrl;
  final double price;
  final int quantity;
  final String title;

  const CartItem(this.id, this.productId, this.imageUrl, this.price,
      this.quantity, this.title);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: ValueKey(id),
        background: Container(
          color: Theme.of(context).errorColor,
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 4,
          ),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text("Are you sure?"),
              content: Text("Do You Want to remove item from the cart?"),
              actions: [
                TextButton(
                  child: Text("No"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text("Yes"),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            ),
          );
        },
        onDismissed: (direction) {
          context.read<Cart>().removeItem(productId);
        },
        child: Card(
          margin: EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 4,
          ),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
              title: Text("$title  ( Price : \$ $price ) "),
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Image(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              subtitle: Text('Total \$ ${price * quantity}'),
              trailing: Text('$quantity x'),
            ),
          ),
        ));
  }
}
