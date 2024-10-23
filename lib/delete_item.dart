import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeleteItemScreen extends StatelessWidget {
  final int itemId;

  DeleteItemScreen({required this.itemId});

  Future<void> deleteItem(BuildContext context) async {
    final response = await http.delete(Uri.parse('http://172.25.208.38:3000/items/$itemId'));
    if (response.statusCode == 200) {
      Navigator.pop(context, true);  // Return 'true' to indicate successful deletion
    } else {
      throw Exception('Failed to delete item');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Item'),
      content: Text('Are you sure you want to delete this item?'),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context, false);  // Return 'false' if canceling
          },
        ),
        ElevatedButton(
          child: Text('Delete'),
          onPressed: () {
            deleteItem(context);
          },
        ),
      ],
    );
  }
}
