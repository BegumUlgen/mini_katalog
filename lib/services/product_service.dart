
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

import '../models/product.dart';

class ProductService {
  final String apiUrl = 'https://wantapi.com/products.php';

  // Yerel JSON dosyasındaki ürünleri okur.
  Future<List<Product>> fetchLocalProducts() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/sample_products.json',
    );

    final decodedData = jsonDecode(jsonString) as List;

    return decodedData
        .map((json) => Product.fromJson(json))
        .toList();
  }

  // API üzerinden ürünleri getirir.
  Future<List<Product>> fetchProducts() async {
    final client = HttpClient();

    try {
      // API adresine GET isteği gönderir.
      final request = await client.getUrl(Uri.parse(apiUrl));

      // API yanıtını alır.
      final response = await request.close();

      if (response.statusCode != 200) {
        throw Exception(
          'Ürünler alınamadı. HTTP: ${response.statusCode}',
        );
      }

      // JSON yanıtını String'e dönüştürür.
      final responseBody =
          await response.transform(utf8.decoder).join();

      // JSON verisini Dart Map yapısına dönüştürür.
      final decodedData = jsonDecode(responseBody);

      if (decodedData['status'] != 'success') {
        throw Exception('API isteği başarısız oldu.');
      }

      // Ürün listesini alır.
      final List productsJson = decodedData['data'];

      // JSON kayıtlarını Product nesnelerine dönüştürür.
      return productsJson
          .map((json) => Product.fromJson(json))
          .toList();
    } finally {
      client.close();
    }
  }
}
