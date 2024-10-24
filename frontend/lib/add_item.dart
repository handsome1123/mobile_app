// add_item.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddItemScreen extends StatelessWidget {
  final Function(Map<String, dynamic>) onItemAdded;

  AddItemScreen({required this.onItemAdded});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  Future<void> addItem(BuildContext context) async {
    final name = nameController.text;
    final description = descriptionController.text;
    final price = double.tryParse(priceController.text) ?? 0.0;

    final response = await http.post(
      Uri.parse('http://172.28.149.34:3000/items'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'description': description, 'price': price}),
    );

    if (response.statusCode == 200) {
      final newItem = json.decode(response.body);
      onItemAdded(newItem); // Notify the parent to add the new item
      Navigator.pop(context); // Go back to the list screen
    } else {
      throw Exception('Failed to add item');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () => addItem(context), // Pass context here
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
