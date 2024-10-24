import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'add_item.dart';
import 'edit_item.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://172.28.149.34:3000/items'));

    if (response.statusCode == 200) {
      setState(() {
        items = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load items');
    }
  }

  //Method to delete an item
  Future<void> deleteItem(int id) async {
    final response =
        await http.delete(Uri.parse('http://172.28.149.34:3000/items/$id'));

    if (response.statusCode == 200) {
      fetchData();
    } else {
      throw Exception('Failed to load items');
    }
  }

  // Refresh
  void addItemToList(Map<String, dynamic>newItem) {
    setState(() {
      items.add(newItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item List'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              IconButton(onPressed: () {
                // Navigate to the AddItemScreen when the button is pressed
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddItemScreen(onItemAdded: addItemToList),
              ),
            );
                }, icon: const Icon(Icons.add)),
            ],
          ),
          Expanded(
            child: Container(
                child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(items[index]['name']),
                        subtitle: Text(items[index]['description']),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Delete Item'),
                                    content: const Text(
                                        'Are you sure you want to delete this item?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            deleteItem(items[index]['id']);
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Delete')),
                                    ],
                                  );
                                });
                          },
                        ),
                      );
                    })),
          )
        ],
      ),
    );
  }
}
