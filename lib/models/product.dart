import 'package:flutter/cupertino.dart';

class Product with ChangeNotifier {
  final String? id;
  final String? title;
  final String? description;
  final double? price;
  final String? imageUrl;
  final bool? isIndividual;
  final int? quantity;
  final bool? isFavorite;
  final bool? isPopular;
  final int? pallets;
  final int? groupMembers;
  Product({
    this.id,
    this.title,
    this.description,
    this.price,
    this.imageUrl,
    this.groupMembers,
    this.isIndividual,
    this.quantity,
    this.isFavorite,
    this.isPopular,
    this.pallets,
  });
  factory Product.fromDocument(doc) {
    return Product(
      id: doc.data()["id"],
      title: doc.data()["title"],
      description: doc.data()["description"],
      price: doc.data()["price"],
      imageUrl: doc.data()["imageUrl"],
      groupMembers: doc.data()["groupMembers"],
      isIndividual: doc.data()["isIndividual"],
      quantity: doc.data()["quantity"],
      isFavorite: doc.data()["isFavorite"],
      isPopular: doc.data()["isPopular"],
      pallets: doc.data()["pallets"],
    );
  }
}
