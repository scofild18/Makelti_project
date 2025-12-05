import 'package:Makelti/logic/cubit/orders/orders_cubit.dart';
import 'package:Makelti/logic/cubit/orders/orders_state.dart' show OrdersState;
import 'package:Makelti/widgets/sliding_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientOrdersManagement extends StatefulWidget {
  const ClientOrdersManagement({super.key});

  @override
  State<ClientOrdersManagement> createState() => _ClientOrdersManagementState();
}

class _ClientOrdersManagementState extends State<ClientOrdersManagement> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        final cubit = context.read<OrdersCubit>();
        final orders = selectedTab == 0
            ? cubit.getClientInMakingOrders()
            : cubit.getClientHistoryOrders();

        return Scaffold(
          backgroundColor: const Color(0xfffaf7f2),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      SizedBox(width: 12),
                      Text(
                    'My Orders',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SlidingButton(
                    tabs: const ["In Making", "History"],
                    selectedIndex: selectedTab,
                    onTabChanged: (index) => setState(() => selectedTab = index),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      Widget bottomButton = const SizedBox.shrink();
                      if (selectedTab == 0 && order.status == "ready") {
                        bottomButton = ElevatedButton(
                          onPressed: () => cubit.clientMarkOrderPicked(order),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff89a979),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            minimumSize: const Size(double.infinity, 38),
                          ),
                          child: const Text("Picked", style: TextStyle(color: Colors.white),),
                        );
                      }

                      return OrderCard(
                        name: order.name,
                        time: order.time,
                        status: order.status,
                        image: order.image,
                        title: order.title,
                        qty: order.qty,
                        price: "${order.price.toStringAsFixed(2)} da",
                        rating: order.rating,
                        onRate: selectedTab == 1 && order.rating == null
                            ? (rate) => cubit.clientRateOrder(order, rate)
                            : null,
                        bottomButton: bottomButton,
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
    this.rating,
    this.onRate,
    required this.bottomButton,
  });

  final String name;
  final String time;
  final String status;
  final String image;
  final String title;
  final int qty;
  final String price;
  final double? rating;
  final void Function(double)? onRate;
  final Widget bottomButton;

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
                      fontWeight: FontWeight.w500),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(price,
                            style: const TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8),
                        if (rating != null)
                          Row(
                            children: [
                              Text(rating!.toStringAsFixed(1),
                                  style: const TextStyle(
                                      fontSize: 14, fontWeight: FontWeight.w500)),
                              const SizedBox(width: 3),
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 20 , ),
                            ],
                          )
                        else if (onRate != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(5, (index) {
                              return GestureDetector(
                                onTap: () => onRate!(index + 1.0),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2),
                                  child: Icon(
                                    Icons.star,
                                    size: 18,
                                    color: index < (rating ?? 0) ? Colors.amber : Colors.grey,
                                  ),
                                ),
                              );
                            }),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          bottomButton,
        ],
      ),
    );
  }
}