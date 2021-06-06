import 'package:flutter/material.dart';
import 'package:flutter_app/providers/auth.dart';
import 'package:flutter_app/providers/cart.dart';
import 'package:flutter_app/providers/product.dart';
import 'package:flutter_app/screens/product_detail_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:another_flushbar/flushbar.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = context.read<Product>();
    final cart = context.read<Cart>();

    final authData = context.read<Auth>();

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(children: [
        GridTile(
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.size,
                alignment: Alignment.center,
                child: ProductDetailScreen(product.id),
              ),
            ),
            child: Hero(
              tag: product.id,
              child: FadeInImage(
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
                placeholder:
                    AssetImage("assets/images/product-placeholder.png"),
              ),
            ),
          ),
          footer: GridTileBar(
            leading: Consumer<Product>(
              builder: (ctx, product, _) => IconButton(
                onPressed: () {
                  product.toggleFavoriteStatus(authData.token, authData.userId);
                },
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            backgroundColor: Colors.purple[900].withOpacity(.8),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
                onPressed: () async {
                  cart.addItem(product.id, product.price, product.title);
                  await Flushbar(
                    title: 'Cart',
                    duration: Duration(seconds: 2),
                    message: 'Add To Cart',
                    mainButton: TextButton(
                      child: Text("Undo!"),
                      onPressed: () {
                        cart.remveSingleItem(product.id);
                      },
                    ),
                  ).show(context);
                },
                icon: Icon(Icons.shopping_cart),
                color: Theme.of(context).accentColor),
          ),
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).accentColor,
                width: 2,
              ),
              color: Colors.white.withOpacity(.6),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                "Price : \$ ${product.price}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
