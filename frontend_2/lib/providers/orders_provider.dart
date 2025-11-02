

import 'package:flutter/material.dart';
import '../models/order.dart';

class OrdersProvider with ChangeNotifier {

  final List<Order> _orders = [
    Order(
      name: "John Smith",
      time: "15 min ago",
      status: "pending",
      image: "assets/images/salad.jpg",
      title: "Homemade Pasta Carbonara",
      qty: 2,
      price: 25.98,
    ),
    Order(
      name: "Sarah Johnson",
      time: "1 hour ago",
      status: "accepted",
      image: "assets/images/salad.jpg",
      title: "Fresh Garden Salad Bowl",
      qty: 1,
      price: 8.50,
    ),
    Order(
      name: "Mike Wilson",
      time: "2 hours ago",
      status: "ready",
      image: "assets/images/salad.jpg",
      title: "Chocolate Layer Cake",
      qty: 1,
      price: 15.00,
    ),
  ];

List<Order> getActiveOrders() {
  List<Order> activeList = [];

  for (var order in _orders) {
    if (order.status != "delivered") {
      activeList.add(order);
    }
  }

  return activeList;
}


List<Order> getCompletedOrders() {
  List<Order> completedList = [];

  for (var order in _orders) {
    if (order.status == "delivered") {
      completedList.add(order);
    }
  }

  return completedList;
}


List<Order> getAllOrders() {
  return _orders;
}

void updateOrderStatus(Order order, String newStatus) {
  final index = _orders.indexOf(order);
  if (index == -1) return;

  _orders[index] = Order(
    name: order.name,
    time: order.time,
    status: newStatus,
    image: order.image,
    title: order.title,
    qty: order.qty,
    price: order.price,
  );
  notifyListeners();
}
}