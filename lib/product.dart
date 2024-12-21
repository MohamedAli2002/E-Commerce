import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product extends StatelessWidget {
  String name;
  String imgage_url;
  String category;
  dynamic price;
  dynamic discount;
  int counter;
  Product(this.name, this.imgage_url, this.category,
      this.price, this.discount,this.counter);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child:
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Column(
                children: [
                  CachedNetworkImage(
                    imageUrl: imgage_url,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                    placeholder: (BuildContext context, String url) => Container(color: Colors.black,),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(
                width: 50,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    price.toString(),
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    (discount).toString() + '%',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    (price - (price * (discount / 100.0))).toString(),
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
