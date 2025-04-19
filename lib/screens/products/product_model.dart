class Product {
  final int productID;
  final String itemNumber;
  final String itemName;
  final double discount;
  final int stock;
  final double unitPrice;
  final String imageURL;
  final String imageFullURL;
  final String status;
  final String description;

  Product({
    required this.productID,
    required this.itemNumber,
    required this.itemName,
    required this.discount,
    required this.stock,
    required this.unitPrice,
    required this.imageURL,
    required this.imageFullURL,
    required this.status,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productID: json['productID'],
      itemNumber: json['itemNumber'],
      itemName: json['itemName'],
      discount: json['discount'].toDouble(),
      stock: json['stock'],
      unitPrice: json['unitPrice'].toDouble(),
      imageURL: json['imageURL'],
      imageFullURL: json['imageFullURL'],
      status: json['status'],
      description: json['description'],
    );
  }
}
