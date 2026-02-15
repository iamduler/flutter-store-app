class Cart {
  final String productName;
  final int productPrice;
  final String category;
  final List<String> images;
  final String vendorId;
  final String vendorName;
  final int productQuantity;
  int quantity;
  final String productId;
  final String description;

  Cart({
    required this.productName,
    required this.productPrice,
    required this.category,
    required this.images,
    required this.vendorId,
    required this.vendorName,
    required this.productQuantity,
    required this.quantity,
    required this.productId,
    required this.description,
  });
}
