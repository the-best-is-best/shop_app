import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' as ord;

class OrderItem extends StatelessWidget {
  final ord.OrderItem order;

  const OrderItem(this.order);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ExpansionTile(
        collapsedBackgroundColor: Colors.white70,
        collapsedTextColor: Colors.black87,
        title: Text(
          '\$ ${order.amount}',
          style: TextStyle(color: Colors.black87),
        ),
        subtitle: Text(
          DateFormat('dd/MM/yyyy hh:mm').format(order.dateTime),
          style: TextStyle(color: Colors.black87),
        ),
        children: order.products
            .map(
              (prod) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    prod.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    '${prod.quantity} x \$ ${prod.price}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
