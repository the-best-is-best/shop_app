import 'package:flutter/material.dart';
import 'package:flutter_app/providers/products.dart';
import 'package:flutter_app/screens/edit_product_screen.dart';
import 'package:flutter_app/widgets/app_drawer.dart';
import 'package:flutter_app/widgets/user_product_item.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class UsersProductsScreen extends StatelessWidget {
  Future<void> _refreshProducts(BuildContext context) async {
    await context.read<Products>().fetchAndSetProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.size,
                alignment: Alignment.center,
                child: EditProductScreen(null),
              ),
            ),
            icon: Icon(Icons.add),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (ctx, AsyncSnapshot snapShot) =>
              snapShot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      child: Consumer<Products>(
                        builder: (ctx, productsData, _) => Padding(
                          padding: EdgeInsets.all(8),
                          child: ListView.builder(
                            itemCount: productsData.items.length,
                            itemBuilder: (_, int i) => Column(
                              children: [
                                UserProductItem(productsData.items[i]),
                                Divider()
                              ],
                            ),
                          ),
                        ),
                      ),
                      onRefresh: () => _refreshProducts(context),
                    )),
    );
  }
}
