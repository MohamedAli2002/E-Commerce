import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DisplayFeedback extends StatelessWidget {
  DisplayFeedback();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Feedbacks'),
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance.collection('feedback').get(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData == false) {
              return const Text('No data');
            } else {
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  var feedback = snapshot.data.docs[index];
                  double rate = double.parse(feedback['rate']);
                  String comment = feedback['commit'];
                  String user = feedback['user'];

                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'User:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(user),
                          const SizedBox(height: 10),
                          const Text(
                            'Feedback:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(comment),
                          const SizedBox(height: 10),
                          const Text(
                            'Rating:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 5),
                          RatingBarIndicator(
                            rating: rate,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 30.0,
                            direction: Axis.horizontal,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}
