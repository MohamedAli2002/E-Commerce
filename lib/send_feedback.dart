import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:online_shopping/variables.dart';

import 'login.dart';

class SendFeedback extends StatefulWidget {

  String username;

  SendFeedback(this.username);
  @override
  State<SendFeedback> createState() => _SendFeedbackState(username);
}

class _SendFeedbackState extends State<SendFeedback> {


  TextEditingController commitTextEdit = new TextEditingController();

  String username;
  double rating = 0; // Holds the user's selected rating

  _SendFeedbackState(this.username);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            height: 100,
          ),
          Center(
            child: Text(
              'Send Feedback and Rate Your Order',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: commitTextEdit,
              decoration: InputDecoration(
                labelText: 'Feedback',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rate:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (value) {
                    setState(() {
                      rating = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
              child: const FittedBox(
                  child: Text(
                    'Send',
                    style: TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 20,
                    ),
                  )),
              //color: Colors.lightBlue,
              onPressed: () {
                FirebaseFirestore.instance.collection('feedback').add(
                  <String, dynamic>{
                    'commit': commitTextEdit.text,
                    'rate': rating.toString(), // Use the selected rating
                    'user': username,
                  },
                );
                Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
