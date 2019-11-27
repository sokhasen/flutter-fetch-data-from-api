class Product {
  final String id;
  final String name;
  final String price;
  final String  image;
  final String quantity;
  final  String description;

  Product(this.id, this.name, this.price, this.image, this.quantity, this.description);

  Product.fromJson(Map<String, dynamic> json):
    id = json['_id'].toString() ?? "",
    name = json['name'].toString() ?? "",
    price = json['price'].toString() ?? '0',
    image = json['image'].toString() ?? '',
    quantity = json['quantity'].toString() ?? '0',
    description = json['description'].toString() ?? "";
  
  static List<Product> fromJsonList(jsonList) {
      if (jsonList != null) {
        return jsonList.map<Product>((obj) => Product.fromJson(obj)).toList();
      }
      return [];
    }
  Map<String, dynamic> toJson() {
    return {
      "name":  this.name,
      "price": this.price,
      "image": this.image,
      "quantity": this.quantity,
      "description": this.description
    };
  }
}