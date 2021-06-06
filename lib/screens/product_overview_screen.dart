import 'package:flutter/material.dart';
import 'package:flutter_app/providers/cart.dart';
import 'package:flutter_app/providers/products.dart';
import 'package:flutter_app/screens/cart_screen.dart';
import 'package:flutter_app/widgets/app_drawer.dart';
import 'package:flutter_app/widgets/badge.dart';
import 'package:flutter_app/widgets/products_grid.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

enum FilterOption { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _isLoading = false;
  var _showOnlyFavorites = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true;

    context.read<Products>().fetchAndSetProduct().then((_) {
      setState(() {
        _isLoading = false;
      });
    }).catchError(
      (_) => setState(() => _isLoading = false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOption selectedVal) {},
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(child: Text('Show All'), value: FilterOption.All),
              PopupMenuItem(
                  child: Text('Only Favorites'), value: FilterOption.Favorites),
            ],
          ),
          Consumer<Cart>(
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.size,
                        alignment: Alignment.center,
                        duration: Duration(milliseconds: 500),
                        child: CartScreen()),
                  );
                },
              ),
              builder: (_, cart, ch) => Badge(
                    child: ch,
                    value: cart.itemCount,
                  )),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorites),
    );
  }
}
