


import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();

  final TextEditingController searchController =
      TextEditingController();

  List<Product> products = [];
  bool isLoading = true;
  String? errorMessage;
  String searchQuery = '';

  List<Product> get filteredProducts {
    if (searchQuery.isEmpty) {
      return products;
    }

    return products.where((product) {
      return product.name
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
    }).toList();
  }

 @override
void initState() {
  super.initState();
  fetchProducts();
 
}


  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // API'den ürünleri getirir.
  Future<void> fetchProducts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await _productService.fetchProducts();

      if (!mounted) return;

      setState(() {
        products = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF211D20),
    appBar: AppBar(
       backgroundColor: const Color(0xFF641C30),
    foregroundColor: Colors.white,
    elevation: 0,
    title: const Text(
      'Mini Katalog',
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    centerTitle: true,
    ),
    body: isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : errorMessage != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Hata: $errorMessage'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: fetchProducts,
                      child: const Text('Tekrar Dene'),
                    ),
                  ],
                ),
              )
              
: Column(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'assets/images/banner.png',
            width: double.infinity,
            height: 150,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 150,
                color: Colors.grey.shade300,
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 40,
                  ),
                ),
              );
            },
          ),
        ),
      ),

      // Buradan sonra mevcut arama kutusu ve GridView kodların devam edecek.

                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Ürün ara...',
                           hintStyle: const TextStyle(color: Colors.white70),
  prefixIcon: const Icon(Icons.search, color: Color(0xFFD99AA6)),
  suffixIcon: IconButton(
                             icon: const Icon(Icons.clear, color: Colors.white70),
    onPressed: () {
      searchController.clear();
      setState(() {
        searchQuery = '';
                              });
                            },
                          ),
                            fillColor: const Color(0xFF38282D),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                             borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: filteredProducts.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.7,
                        ),
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetailScreen(
                                    product: product,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                               color: const Color(0xFFF5F0ED),
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      product.image,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Center(
                                          child: Icon(
                                            Icons.image_not_supported,
                                            size: 45,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style:  TextStyle(
                                            color:  Color(0xFF292124),
fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          '${product.price} ${product.currency}',
                                          style: const TextStyle(
                                            color:  Color(0xFF9B293F),
fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
