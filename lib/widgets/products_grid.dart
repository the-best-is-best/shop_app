import 'package:flutter/material.dart';
import 'package:flutter_app/providers/products.dart';
import 'package:flutter_app/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  const ProductsGrid(this.showFavs);
  @override
  Widget build(BuildContext context) {
    final productData = context.read<Products>();
    final products = showFavs ? productData.favoriteItems : productData.items;
    return products.isEmpty
        ? Center(child: Text("There is no product"))
        : GridView.builder(
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (ctx, int i) => ChangeNotifierProvider.value(
              value: products[i],
              child: ProductItem(),
            ),
          );
  }
}
