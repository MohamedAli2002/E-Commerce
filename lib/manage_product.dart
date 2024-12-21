import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_shopping/update_document.dart';

import 'deleteDocument.dart';

class ManageProduct extends StatefulWidget {
  const ManageProduct({super.key});

  @override
  State<ManageProduct> createState() => _ManageProductState();
}

class _ManageProductState extends State<ManageProduct> {
  TextEditingController productNameTextEdit = new TextEditingController();
  TextEditingController newProductNameTextEdit = new TextEditingController();
  TextEditingController newProductPriceTextEdit = new TextEditingController();
  TextEditingController newProductImageTextEdit = new TextEditingController();
  TextEditingController newProductDiscountTextEdit =
      new TextEditingController();
  TextEditingController newProductStockTextEdit = new TextEditingController();
  TextEditingController newProductSoldTextEdit = new TextEditingController();
  TextEditingController newProductIdTextEdit = new TextEditingController();
  TextEditingController newProductCategoryTextEdit =
      new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: productNameTextEdit,
                decoration: InputDecoration(
                  labelText: 'Enter Product Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Enter New Product Name For Edit : ',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: newProductNameTextEdit,
                decoration: InputDecoration(
                  labelText: 'Enter New Product Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: newProductPriceTextEdit,
                decoration: InputDecoration(
                  labelText: 'Enter New Product Price',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: newProductDiscountTextEdit,
                decoration: InputDecoration(
                  labelText: 'Enter New Product Discount',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: newProductStockTextEdit,
                decoration: InputDecoration(
                  labelText: 'Enter New Product Number of Stock',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: newProductSoldTextEdit,
                decoration: InputDecoration(
                  labelText: 'Enter New Product Number of Sold',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: newProductPriceTextEdit,
                decoration: InputDecoration(
                  labelText: 'Enter New Product Image ulr',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: newProductIdTextEdit,
                decoration: InputDecoration(
                  labelText: 'Enter New Product ID',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: newProductCategoryTextEdit,
                decoration: InputDecoration(
                  labelText: 'Enter New Product Category',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                child: const FittedBox(
                    child: Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.lightBlue,
                    fontSize: 20,
                  ),
                )),
                //color: Colors.lightBlue,
                onPressed: () async {
                  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                      .collection('products')
                      .where('name', isEqualTo: newProductNameTextEdit.text)
                      .get();
                  if (querySnapshot.docs.isNotEmpty) {
                    FirebaseFirestore.instance.collection('products').add(
                      <String, dynamic>{
                        'name': newProductNameTextEdit.text,
                        'category': newProductCategoryTextEdit.text,
                        'discount':
                            double.parse(newProductDiscountTextEdit.text),
                        'id': newProductIdTextEdit.text,
                        'imgname': newProductImageTextEdit.text,
                        'price': double.parse(newProductPriceTextEdit.text),
                        'stock': double.parse(newProductStockTextEdit.text),
                        'sold': 0,
                      },
                    );
                    const snackBar = SnackBar(
                      content: Text('New Product Added'),
                      backgroundColor: Colors.green,
                    );
                  } else {
                    const snackBar = SnackBar(
                      content: Text(
                          'There Is Product With Same Name,Try Another Name'),
                      backgroundColor: Colors.red,
                    );
                  }
                },
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                child: const FittedBox(
                    child: Text(
                  'Update',
                  style: TextStyle(
                    color: Colors.lightBlue,
                    fontSize: 20,
                  ),
                )),
                onPressed: () {
                  const snackBar = SnackBar(
                    content: Text('Product Updated'),
                    backgroundColor: Colors.green,
                  );
                  final userRef =
                      FirebaseFirestore.instance.collection('products');
                  userRef.get().then((QuerySnapshot snapshot) async {
                    for (int index = 0; index < snapshot.size; index++) {
                      if (snapshot.docs[index]['name'] ==
                          productNameTextEdit.text) {
                        Map<String, dynamic> updateMap = {
                          'name': newProductNameTextEdit.text,
                          'category': newProductCategoryTextEdit.text,
                          'discount':
                              double.parse(newProductDiscountTextEdit.text),
                          'id': newProductIdTextEdit.text,
                          'imgname': newProductImageTextEdit.text,
                          'price': double.parse(newProductPriceTextEdit.text),
                          'stock': double.parse(newProductStockTextEdit.text),
                          'sold': double.parse(newProductSoldTextEdit.text),
                        };
                        updateDocument('products', 'name',
                            productNameTextEdit.text, updateMap);
                      }
                    }
                  });
                },
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                child: const FittedBox(
                    child: Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.lightBlue,
                    fontSize: 20,
                  ),
                )),
                onPressed: () {
                  const snackBar = SnackBar(
                    content: Text('product Deleted'),
                    backgroundColor: Colors.green,
                  );
                  final userRef =
                      FirebaseFirestore.instance.collection('products');
                  userRef.get().then((QuerySnapshot snapshot) async {
                    for (int index = 0; index < snapshot.size; index++) {
                      if (snapshot.docs[index]['name'] ==
                          productNameTextEdit.text) {
                        deleteDocument(
                            'products', 'name', productNameTextEdit.text);
                      }
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
