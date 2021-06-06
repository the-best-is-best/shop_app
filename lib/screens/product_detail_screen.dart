import 'package:flutter/material.dart';
import 'package:flutter_app/providers/products.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final productId;

  const ProductDetailScreen(this.productId);
  @override
  Widget build(BuildContext context) {
    final loadedProduct = context.read<Products>().findById(productId);
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.purple.withOpacity(.5),
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(loadedProduct.title),
                background: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48.0,
                    vertical: 10,
                  ),
                  child: Hero(
                      tag: loadedProduct.id,
                      child: Image.network(
                        loadedProduct.imageUrl,
                        fit: BoxFit.cover,
                      )),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\$ ${loadedProduct.price}",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    child: Text(
                      loadedProduct.description,
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
