import 'package:flutter/material.dart';
import 'package:flutter_app/providers/product.dart';
import 'package:flutter_app/providers/products.dart';
import 'package:flutter_app/screens/edit_product_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final Product product;

  const UserProductItem(this.product);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.size,
                  alignment: Alignment.center,
                  child: EditProductScreen(product.id),
                ),
              ),
              icon: Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () async {
                try {
                  await context.read<Products>().deleteProduct(product.id);
                } catch (e) {
                  ScaffoldMessenger(
                    child: SnackBar(
                        content: Text(
                      "Deleting Failed!",
                      textAlign: TextAlign.center,
                    )),
                  );
                }
              },
              color: Theme.of(context).errorColor,
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}

class Flushbar {}
