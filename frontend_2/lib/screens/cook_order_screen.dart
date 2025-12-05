import 'package:Makelti/logic/cubit/orders/orders_cubit.dart';
import 'package:Makelti/logic/cubit/orders/orders_state.dart' show OrdersState;
import 'package:Makelti/widgets/sliding_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CookOrdersScreen extends StatefulWidget {
  const CookOrdersScreen({super.key});

  @override
  State<CookOrdersScreen> createState() => _CookOrdersScreenState();
}

class _CookOrdersScreenState extends State<CookOrdersScreen> {
  int selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        final cubit = context.read<OrdersCubit>();
        final orders = selectedTab == 0
            ? cubit.cookGetActiveOrders()
            : cubit.cookGetCompletedOrders();
        return Scaffold(
          backgroundColor: const Color(0xfffaf7f2),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
              padding: EdgeInsets.only(left: 12.0, top: 12),
              child: Row(
                children: [
                  SizedBox(width: 12),
                  Text(
                    'my Orders',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SlidingButton(
                    tabs: const ["Active Orders", "Completed"],
                    selectedIndex: selectedTab,
                    onTabChanged: (index) {
                      setState(() => selectedTab = index);
                    },
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];

                      Widget buttons;
                      if (order.status == "pending") {
                        buttons = Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  cubit.cookUpdateOrderStatus(order, "rejected");
                                },
                                icon: const Icon(Icons.close, color: Colors.redAccent),
                                label: const Text("Reject",
                                    style: TextStyle(color: Colors.redAccent)),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.redAccent),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  cubit.cookUpdateOrderStatus(order, "accepted");
                                },
                                icon: const Icon(Icons.check, color: Colors.white),
                                label: const Text("Accept" , style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff89a979),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else if (order.status == "accepted") {
                        buttons = ElevatedButton(
                          onPressed: () {
                            cubit.cookUpdateOrderStatus(order, "ready");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffe97844),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            minimumSize: const Size(double.infinity, 38),
                          ),
                          child: const Text("Mark as Ready" , style: TextStyle(color: Colors.white)),
                        );
                      } else if (order.status == "ready") {
                        buttons = ElevatedButton.icon(
                          onPressed: () {
                            cubit.cookUpdateOrderStatus(order, "delivered");
                          },
                          icon: const Icon(Icons.check, color: Colors.white),
                          label: const Text("Mark as Delivered" ,style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff89a979),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            minimumSize: const Size(double.infinity, 38),
                          ),
                        );
                      } else {
                        buttons = const SizedBox.shrink();
                      }

                      return OrderCard(
                        name: order.name,
                        time: order.time,
                        status: order.status,
                        image: order.image,
                        title: order.title,
                        qty: order.qty,
                        price: "${order.price.toStringAsFixed(2)} da ",
                        buttons: buttons,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.name,
    required this.time,
    required this.status,
    required this.image,
    required this.title,
    required this.qty,
    required this.price,
    required this.buttons,
  });

  final String name;
  final String time;
  final String status;
  final String image;
  final String title;
  final int qty;
  final String price;
  final Widget buttons;

  @override
  Widget build(BuildContext context) {
    Color statusColor = switch (status) {
      "pending" => const Color(0xffdcd5c9),
      "accepted" => const Color(0xffe97844),
      "ready" => const Color(0xffe97844),
      "delivered" => Colors.green,
      _ => Colors.grey,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(time,
                      style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  image,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text("Qty: $qty", style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(price,
                        style: const TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          buttons,
        ],
      ),
    );
  }
}