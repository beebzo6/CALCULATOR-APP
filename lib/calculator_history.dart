import 'package:flutter/material.dart';

class CalculatorHistory extends StatelessWidget {
  const CalculatorHistory({super.key, required this.calculatedHistory});
  final List<String> calculatedHistory;
  // final void Function()
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculaton History"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              print("delete history");
            },
          ),
        ],
      ),

      body: ListView.builder(
        itemCount: calculatedHistory.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              calculatedHistory[index],
              style: const TextStyle(fontSize: 20),
            ),
          );
        },
      ),
    );
  }
}
