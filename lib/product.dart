import 'dart:convert';

class Product {
  int id;
  int amount;
  String name;
  String brand;
  String validity;

  Product({this.id, this.amount, this.name, this.brand, this.validity});

  //get products
  factory Product.fromJson(Map<String, dynamic> map) {
    return Product(
        id: map["id"],
        amount: map["amount"],
        name: map["name"],
        brand: map["brand"],
        validity: map["validity"]);
  }

  //update, delete, insert products
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "amount": amount,
      "name": name,
      "brand": brand,
      "validity": validity
    };
  }

  //convert to String
  @override
  String toString() {
    // TODO: implement toString
    return 'Product{id: $id, amount: $amount, name: $name, brand: $brand, validity: $validity}';
  }
}

  //list of products
  List<Product> productFromJson(String jsonData) {
    final data = json.decode(jsonData);
    return List<Product>.from(data.map((item) => Product.fromJson(item)));
  }

  String productToJson(Product product) {
    final jsonData = product.toJson();
    return json.encode(jsonData);
  }
