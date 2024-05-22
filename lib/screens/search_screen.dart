import 'package:flutter/material.dart';
import '../helper/bottom_navbar.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';


class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    final productBloc = ProductProvider.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 60), // Adjusted space from top
            const Text(
              'Search for products',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 15, 119, 203),
              ),
            ),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search for products',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    productBloc.searchProducts(searchController.text);
                  },
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Product>>(
                stream: productBloc.searchedProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No products found'));
                  }

                  final products = snapshot.data!;
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ListTile(
                        title: Text(product.name),
                        subtitle: Text(product.details),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/restaurantsproducts',
                            arguments: product.name,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavbar(
        currentIndex: 0,
        onTap: (index) => BottomNavbar.navigateTo(context, index),
      ),
    );
  }
}
