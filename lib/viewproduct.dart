import 'package:flutter/material.dart';
import 'package:online_shopping/product.dart';
import 'package:online_shopping/variables.dart';

class Viewproduct extends StatelessWidget {
  String name;
  String imgname;
  dynamic price;
  dynamic discount;
  String category;
  Viewproduct(this.imgname,this.discount,this.price,this.category,this.name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('View Product'),backgroundColor: Colors.lightBlue,),
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Product(name, imgname, category, price, discount,1),
            SizedBox(height: 10,),
            ElevatedButton(
                onPressed:(){
              cart_list.add(Product(name, imgname, category, price, discount,1));
              var snackBar = SnackBar(
                content: Text(name + ' Add to cart'),
                backgroundColor: Colors.green,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              //print(cart_list);
            }, child: Text("Add to cart"))
          ],
        ),
      ),
    );
  }
}
