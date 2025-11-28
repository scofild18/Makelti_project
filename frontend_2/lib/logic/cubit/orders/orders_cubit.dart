import 'package:flutter_bloc/flutter_bloc.dart';
import 'orders_state.dart';
import 'package:Makelti/models/order.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super( OrdersState(orders: _initialOrders));

  static  final List<Order> _initialOrders = [
    Order(
      name: "John Smith",
      time: "15 min ago",
      status: "pending",
      image: "assets/images/salad.jpg",
      title: "Homemade Pasta Carbonara",
      qty: 2,
      price: 250,
    ),
    Order(
      name: "Sarah Johnson",
      time: "1 hour ago",
      status: "accepted",
      image: "assets/images/salad.jpg",
      title: "Fresh Garden Salad Bowl",
      qty: 1,
      price: 350,
    ),
    Order(
      name: "Mike Wilson",
      time: "2 hours ago",
      status: "ready",
      image: "assets/images/salad.jpg",
      title: "Chocolate Layer Cake",
      qty: 1,
      price: 150,
    ),
  ];


/// Cook side funcitions 
  List<Order> cookGetActiveOrders() {
    List<Order> activeList = [];

    for (var order in state.orders) {
      if (order.status != "delivered") {
        activeList.add(order);
      }
    }

    return activeList;
  }

  List<Order> cookGetCompletedOrders() {
    List<Order> completedList = [];

    for (var order in state.orders) {
      if (order.status == "delivered") {
        completedList.add(order);
      }
    }

    return completedList;
  }

  void cookUpdateOrderStatus(Order order, String newStatus) {
    List<Order> updatedOrders = [];

    for (var o in state.orders) {
      if (o == order) {
        updatedOrders.add(
          Order(
            name: o.name,
            time: o.time,
            status: newStatus,
            image: o.image,
            title: o.title,
            qty: o.qty,
            price: o.price,
          ),
        );
      } else {
        updatedOrders.add(o);
      }
    }

    emit(state.copyWith(orders: updatedOrders));
  }


  /// CLient Side functions

  List<Order> getClientInMakingOrders() {
    List<Order> inMaking = [];
    for (var order in state.orders) {
      if (order.status == "pending" || order.status == "accepted" || order.status == "ready") {
        inMaking.add(order);
      }
    }
    return inMaking;
  }

  List<Order> getClientHistoryOrders() {
    List<Order> history = [];
    for (var order in state.orders) {
      if (order.status == "delivered") {
        history.add(order);
      }
    }
    return history;
  }

  void clientMarkOrderPicked(Order order) {
    cookUpdateOrderStatus(order, "delivered");
  }

  void clientRateOrder(Order order, double rating) {
    List<Order> updatedOrders = [];
    for (var o in state.orders) {
      if (o == order) {
        updatedOrders.add(
          Order(
            name: o.name,
            time: o.time,
            status: o.status,
            image: o.image,
            title: o.title,
            qty: o.qty,
            price: o.price,
            rating: rating,
          ),
        );
      } else {
        updatedOrders.add(o);
      }
    }
    emit(state.copyWith(orders: updatedOrders));
  }
}