import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/send_feedback.dart';
import 'package:online_shopping/update_document.dart';
import 'package:online_shopping/variables.dart';
import 'package:intl/intl.dart';

class Cart extends StatefulWidget {
  String username;
  Cart(this.username);

  @override
  State<Cart> createState() => _CartState(username);
}

class _CartState extends State<Cart> {
  double total_price = 0.0;
  String username;
  _CartState(this.username);

  @override
  void initState() {
    super.initState();
    calculateTotalPrice();
  }

  String getCurrentDate() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd'); // Change format as needed
    return formatter.format(now);
  }

  void calculateTotalPrice() {
    total_price = 0.0;
    for (var item in cart_list) {
      double price = item.price.toDouble();
      double discount = item.discount.toDouble();

      double discountedPrice = price - (price * (discount / 100.0));
      total_price += discountedPrice * item.counter;
    }
  }

  void add(int index) {
    setState(() {
      cart_list[index].counter++;
      calculateTotalPrice();
    });
  }

  void minus(int index) {
    setState(() {
      if (cart_list[index].counter > 1) {
        cart_list[index].counter--;
      } else {
        cart_list.removeAt(index);
      }
      calculateTotalPrice();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Cart'), backgroundColor: Colors.lightBlue),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart_list.length,
              itemBuilder: (context, index) {
                var item = cart_list[index];
                double price = item.price.toDouble();
                double discount = item.discount.toDouble();
                double discountedPrice = price - (price * (discount / 100.0));

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const SizedBox(width: 25),
                      Column(
                        children: [
                          CachedNetworkImage(
                            imageUrl: item.imgage_url,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            placeholder: (BuildContext context, String url) =>
                                Container(color: Colors.black),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            item.name,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            price.toString(),
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${item.discount}%',
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            discountedPrice.toString(),
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(width: 25),
                      Column(
                        children: [
                          const SizedBox(height: 10),
                          FloatingActionButton(
                            onPressed: () {
                              add(index);
                            },
                            child: const Icon(Icons.add, color: Colors.white),
                            backgroundColor: Colors.green,
                            shape: const CircleBorder(),
                          ),
                          const SizedBox(height: 10),
                          Text('${item.counter}',
                              style: const TextStyle(fontSize: 20.0)),
                          const SizedBox(height: 10),
                          FloatingActionButton(
                            onPressed: () {
                              minus(index);
                            },
                            child:
                                const Icon(Icons.remove, color: Colors.white),
                            backgroundColor: Colors.red,
                            shape: const CircleBorder(),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                for (var item in cart_list) {
                  // Add transaction to the transactions collection
                  await FirebaseFirestore.instance
                      .collection('transactions')
                      .add(
                    <String, dynamic>{
                      'user': username,
                      'product': item.name,
                      'counter': item.counter.toString(),
                      'date': getCurrentDate(),
                      'price':
                          (item.price - (item.price * (item.discount / 100.0)))
                              .toString(),
                    },
                  );

                  int currentSold = 0;
                  int currentStock = 0;

                  final userRef =
                      FirebaseFirestore.instance.collection('products');
                  userRef.get().then((QuerySnapshot snapshot) {
                    for (int index = 0; index < snapshot.size; index++) {
                      if (snapshot.docs[index]['name'] == item.name)
                        {
                          if (snapshot.docs[index]['stock'] > item.counter)
                            {
                              currentSold = snapshot.docs[index]['sold'] ?? 0;
                              currentStock = snapshot.docs[index]['stock'] ?? 0;

                              Map<String, dynamic> updateMap = {
                                "sold": currentSold + item.counter,
                                "stock": currentStock - item.counter,
                              };
                              updateDocument("products", 'name', item.name, updateMap);
                              break;
                            }
                          else
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Can not Submit this order, Not Enough product "+"${item.name}"
                                    +" in the stock"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                        }
                    }
                  });
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SendFeedback(username)),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: $e")),
                );
              }
            },
            child: const Text('Submission'),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 10,
              ),
              const Text("Total Price: ", style: TextStyle(fontSize: 20)),
              Text(
                '\$${total_price.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
