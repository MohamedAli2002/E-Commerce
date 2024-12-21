import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_shopping/update_document.dart';

import 'deleteDocument.dart';

class ManageCategory extends StatefulWidget {
  const ManageCategory({super.key});

  @override
  State<ManageCategory> createState() => _ManageCategoryState();
}

class _ManageCategoryState extends State<ManageCategory> {
  TextEditingController categoryNameTextEdit = new TextEditingController();
  TextEditingController newCategoryNameTextEdit = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              'Enter Category Name For Add/Edit/Delete : ',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: categoryNameTextEdit,
                decoration: InputDecoration(
                  labelText: 'Enter Category Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Enter New Category Name For Edit : ',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: newCategoryNameTextEdit,
                decoration: InputDecoration(
                  labelText: 'Enter New Category Name',
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
                      .collection('category')
                      .where('name', isEqualTo: newCategoryNameTextEdit.text)
                      .get();
                  if(querySnapshot.docs.isNotEmpty)
                    {
                      FirebaseFirestore.instance.collection('category').add(
                        <String, dynamic>{
                          'name': categoryNameTextEdit.text,
                        },
                      );
                      const snackBar = SnackBar(
                        content: Text('New Category Added'),
                        backgroundColor: Colors.green,
                      );
                    }
                  else
                    {
                      const snackBar = SnackBar(
                        content: Text('There Is Category With Same Name,Try Another Name'),
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
                    content: Text('Category Updated'),
                    backgroundColor: Colors.green,
                  );
                  final userRef =
                      FirebaseFirestore.instance.collection('category');
                  userRef.get().then((QuerySnapshot snapshot) async {
                    for (int index = 0; index < snapshot.size; index++) {
                      if (snapshot.docs[index]['name'] ==
                          categoryNameTextEdit.text) {
                        Map<String, dynamic> updateMap = {
                          "name": newCategoryNameTextEdit.text,
                        };
                        updateDocument('category', 'name',
                            categoryNameTextEdit.text, updateMap);
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
                  final userRef2 =
                      FirebaseFirestore.instance.collection('products');
                  userRef2.get().then((QuerySnapshot snapshot) async {
                    for (int index = 0; index < snapshot.size; index++) {
                      if (snapshot.docs[index]['category'] ==
                          categoryNameTextEdit.text) {
                        const snackBar = SnackBar(
                          content: Text('Can not Delete this Category'),
                          backgroundColor: Colors.green,
                        );
                      } else {
                        deleteDocument(
                            'category', 'name', categoryNameTextEdit.text);
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
