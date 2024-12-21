import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Transactions extends StatefulWidget {
  Transactions();

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  TextEditingController searchTextEdit = TextEditingController();

  _TransactionsState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Center(
          child: Text(
            'Transactions',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: searchTextEdit,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchTextEdit.clear();
                    setState(() {}); // Trigger UI update
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                labelText: 'Search by Date',
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('transactions')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No transactions found.'));
                }

                final filteredDocs = snapshot.data!.docs.where((doc) {
                  final date = doc['date']?.toString() ?? '';
                  return searchTextEdit.text.isEmpty ||
                      date.contains(searchTextEdit.text);
                }).toList();

                if (filteredDocs.isEmpty) {
                  return const Center(child: Text('No transactions match your search.'));
                }

                return ListView.builder(
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final data = filteredDocs[index].data() as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text('Product Name: ${data['product'] ?? 'N/A'}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Counter: ${data['counter'] ?? 'N/A'}'),
                            Text('Date: ${data['date'] ?? 'N/A'}'),
                            Text('User: ${data['user'] ?? 'N/A'}'),
                          ],
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
