import 'package:Makelti/models/order.dart';

class OrdersState {
  final List<Order> orders;

  OrdersState({required this.orders});

  OrdersState copyWith({List<Order>? orders}) {
    return OrdersState(
      orders: orders ?? this.orders,
    );
  }
}