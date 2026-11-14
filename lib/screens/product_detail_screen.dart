
import 'package:flutter/material.dart';
import '../models/product.dart';
import 'cart_screen.dart';
import '../services/cart_service.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF211D20),
      appBar: AppBar(
        backgroundColor: const Color(0xFF641C30),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Ürün Detayı',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F0ED),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.image,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF292124),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.tagline,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF756A6D),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${product.price} ${product.currency}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9B293F),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Ürün Açıklaması',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF292124),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.description,
                style: const TextStyle(
                  color: Color(0xFF443A3D),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Teknik Özellikler',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF292124),
                ),
              ),
              const SizedBox(height: 8),
              ...product.specs.entries.map(
                (entry) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    entry.key,
                    style: const TextStyle(
                      color: Color(0xFF292124),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    entry.value.toString(),
                    style: const TextStyle(
                      color: Color(0xFF756A6D),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF641C30),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    CartService.instance.addProduct(product);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ürün sepete eklendi!'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('Sepete Ekle'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
