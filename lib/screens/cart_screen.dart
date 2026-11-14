
import 'package:flutter/material.dart';
import '../services/cart_service.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = CartService.instance;

    return Scaffold(
      backgroundColor: const Color(0xFF211D20),
      appBar: AppBar(
        backgroundColor: const Color(0xFF641C30),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Sepetim',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: cart,
        builder: (context, child) {
          if (cart.items.isEmpty) {
            return const Center(
              child: Text(
                'Sepetiniz şu anda boş.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
            );
          }

          double totalPrice = 0;

          for (final product in cart.items) {
            final price = double.tryParse(
              product.price.replaceAll(',', '.').replaceAll(
                RegExp(r'[^0-9.]'),
                '',
              ),
            );

            totalPrice += price ?? 0;
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final product = cart.items[index];

                    return Card(
                      color: const Color(0xFFF5F0ED),
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.image,
                            width: 55,
                            height: 55,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.image_not_supported,
                                color: Color(0xFF9B293F),
                              );
                            },
                          ),
                        ),
                        title: Text(
                          product.name,
                          style: const TextStyle(
                            color: Color(0xFF292124),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${product.price} ${product.currency}',
                          style: const TextStyle(
                            color: Color(0xFF9B293F),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Color(0xFF9B293F),
                          ),
                          onPressed: () {
                            cart.removeProduct(product);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F0ED),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Toplam:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF292124),
                      ),
                    ),
                    Text(
                      totalPrice.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9B293F),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
