
import 'package:flutter/material.dart';
import '../models/product.dart';

class CartService extends ChangeNotifier {
  static final CartService instance = CartService._();

  CartService._();

  final List<Product> items = [];

  // Sepete ürün ekler.
  void addProduct(Product product) {
    items.add(product);
    notifyListeners();
  }

  // Sepetten ürün çıkarır.
  void removeProduct(Product product) {
    items.remove(product);
    notifyListeners();
  }

  // Sepetteki ürün sayısını verir.
  int get itemCount => items.length;
}
