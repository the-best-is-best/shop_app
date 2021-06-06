import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({this.id, this.amount, this.products, this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  String authToken;
  String userId;

  getData(String _authToken, String uId, List<OrderItem> orders) {
    authToken = _authToken;
    userId = uId;
    _orders = orders;
    notifyListeners();
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<dynamic> fetchAndSetOrders() async {
    final url =
        "https://shop-app-87bd6-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken";

    try {
      final res = await http.get(Uri.parse(url));
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      final List<OrderItem> loadedOrders = [];
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            amount: orderData['amount'],
            products: (orderData['products'] as List<dynamic>)
                .map((item) => CartItem(
                      id: item['id'],
                      price: item['price'],
                      quantity: item['quantity'],
                      title: item['title'],
                    ))
                .toList(),
            dateTime: DateTime.parse(
              orderData['dateTime'],
            ),
          ),
        );
      });

      _orders = loadedOrders.reversed.toList();
      notifyListeners();
      return 'success';
    } catch (e) {
      throw e;
    }
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final url =
        "https://shop-app-87bd6-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken";

    try {
      final timestamp = DateTime.now();
      final res = await http.post(Uri.parse(url),
          body: json.encode({
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'products': cartProduct
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price
                    })
                .toList(),
          }));
      _orders.insert(
          0,
          OrderItem(
              id: json.decode(res.body)['name'],
              amount: total,
              dateTime: timestamp,
              products: cartProduct));

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
