import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/variables.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'profile.dart';
import 'viewproduct.dart';
import 'cart.dart';

class Home extends StatefulWidget {
  final String username;
  final String email;

  Home(this.username, this.email);

  @override
  State<Home> createState() => _HomeState(username, email);
}

class _HomeState extends State<Home> {
  final String username;
  final String email;
  final TextEditingController searchController = TextEditingController();
  final stt.SpeechToText speech = stt.SpeechToText();
  bool isListening = false;
  List<String> categories = ["All Products"];
  String selectedCategory = "All Products";
  List<Map<String, dynamic>> products = [];
  bool isLoading = false;

  _HomeState(this.username, this.email);

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchProducts();
  }

  void fetchCategories() async {
    final categoryCollection =
        FirebaseFirestore.instance.collection('category');
    final snapshot = await categoryCollection.get();

    setState(() {
      categories
          .addAll(snapshot.docs.map((doc) => doc['name'].toString()).toList());
    });
  }

  void fetchProducts([String? category]) async {
    setState(() {
      isLoading = true;
      products = [];
    });

    final productCollection = FirebaseFirestore.instance.collection('products');
    Query query = productCollection;

    if (category != null && category != "All Products") {
      query = query.where('category', isEqualTo: category);
    }

    final snapshot = await query.get();
    setState(() {
      products = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      isLoading = false;
    });
  }

  void onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
    fetchProducts(category);
  }

  Future<void> startListening() async {
    bool available = await speech.initialize();
    if (available) {
      setState(() {
        isListening = true;
      });
      speech.listen(
        onResult: (val) {
          setState(() {
            searchController.text = val.recognizedWords.toLowerCase();
          });
        },
      );
    }
  }

  void stopListening() {
    setState(() {
      isListening = false;
    });
    speech.stop();
  }

  // Barcode scanning
  Future<void> scanBarcode() async {
    try {
      var result = await BarcodeScanner.scan();
      if (result.rawContent.isNotEmpty) {
        // Search for product by ID
        final userRef = FirebaseFirestore.instance.collection('products');
        userRef
            .where('id', isEqualTo: result.rawContent)
            .get()
            .then((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            final product = snapshot.docs.first;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Viewproduct(
                  product['imgname'],
                  product['discount'],
                  product['price'],
                  product['category'],
                  product['name'],
                ),
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Not Found'),
                content: const Text('No product found with this barcode.'),
              ),
            );
          }
        });
      }
    } catch (e) {
      print('Barcode scan error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 70,
                  child: Row(
                    children: [
                      const SizedBox(width: 15),
                      CircleAvatar(
                        backgroundColor: Colors.brown,
                        child: Text(widget.username[0].toUpperCase()),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            widget.username,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                TextButton(
                  child: const Row(
                    children: [
                      Icon(Icons.account_circle),
                      SizedBox(width: 10),
                      Text('Profile'),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profile(username, email),
                      ),
                    );
                  },
                ),
                TextButton(
                  child: const Row(
                    children: [
                      Icon(Icons.shopping_cart),
                      SizedBox(width: 10),
                      Text('Cart'),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Cart(username),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Center(
          child: Text(
            'HomePage',
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: isListening ? stopListening : startListening,
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: scanBarcode,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              savePref(false, '', '');
              Navigator.of(context).pop(null);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                labelText: 'Search',
                prefixIcon: IconButton(
                  onPressed: () {
                    final userRef =
                        FirebaseFirestore.instance.collection('products');
                    userRef.get().then((QuerySnapshot snapshot) {
                      for (int index = 0; index < snapshot.size; index++) {
                        if (snapshot.docs[index]['name'] ==
                            searchController.text) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Viewproduct(
                                snapshot.docs[index]['imgname'],
                                snapshot.docs[index]['discount'],
                                snapshot.docs[index]['price'],
                                snapshot.docs[index]['category'],
                                snapshot.docs[index]['name'],
                              ),
                            ),
                          );
                        }
                      }
                    });
                  },
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
          ),
          // Categories list
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == selectedCategory;

                return GestureDetector(
                  onTap: () => onCategorySelected(category),
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.lightBlue : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                      border: isSelected
                          ? Border.all(color: Colors.blue, width: 2)
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Product list or no product message
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : products.isEmpty
                    ? const Center(
                        child: Text(
                          'No Product Added Yet',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ListTile(
                            leading: CachedNetworkImage(
                              imageUrl: product['imgname'],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              placeholder: (BuildContext context, String url) =>
                                  Container(
                                color: Colors.black,
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            title: Text(product['name'] ?? 'Unknown'),
                            subtitle: Text(
                              "Price: ${product['price']}\nCategory: ${product['category']}",
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Viewproduct(
                                    product['imgname'],
                                    product['discount'],
                                    product['price'],
                                    product['category'],
                                    product['name'],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
