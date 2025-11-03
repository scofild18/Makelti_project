 class Order { 
  final String name;
  final String time;
  final String status;
  final String image;
  final String title;
  final int qty;
  final double price;

  Order({
    required this.name,
    required this.time,
    required this.status,
    required this.image,
    required this.title,
    required this.qty,
    required this.price,
  });
}