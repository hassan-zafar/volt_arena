import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volt_arena/models/product.dart';

class ProductAPI {
  static const String _collection = 'products';
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;
  // functions
  Future<void> addProduct(Product product) async {
    await _instance
        .collection(_collection)
        .doc(product.productId)
        .set(product.toMap());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllProducts() async {
    return await _instance.collection(_collection).get();
  }

  Future<List<Product>> searchProducts(String name) async {
    QuerySnapshot<Map<String, dynamic>> _doc = await FirebaseFirestore.instance
        .collection(_collection)
        .where('title', isGreaterThanOrEqualTo: name.toUpperCase())
        .get();
    List<Product> _products = <Product>[];
    for (DocumentSnapshot<Map<String, dynamic>> docss in _doc.docs) {
      _products.add(Product.fromDocument(docss));
    }
    return _products;
  }
}
