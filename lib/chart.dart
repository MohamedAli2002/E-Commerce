import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  const Chart({Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .orderBy('sold', descending: true)
          .limit(5)
          .get();

      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print("Error fetching data: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Top 5 Best Selling Products"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading data."));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No data found."));
          }

          final data = snapshot.data!;

          // Format data for the bar chart
          final barData = data
              .asMap()
              .entries
              .map((entry) => BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value['sold'].toDouble(),
                color: Colors.blue,
                width: 20,
              )
            ],
          ))
              .toList();

          final productNames = data.map((e) => e['name'] as String).toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: BarChart(
                    BarChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 10, // Y-axis
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 18),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true, // X - Axis
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= productNames.length) return Container();
                              return Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  productNames[value.toInt()],
                                  style: const TextStyle(fontSize: 7),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(
                        border: const Border(
                          left: BorderSide(),
                          bottom: BorderSide(),
                        ),
                      ),
                      barGroups: barData,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
