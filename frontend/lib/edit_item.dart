import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateItemScreen extends StatefulWidget {
  final dynamic item;

  UpdateItemScreen({required this.item});

  @override
  _UpdateItemScreenState createState() => _UpdateItemScreenState();
}

class _UpdateItemScreenState extends State<UpdateItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String description;
  late double price;

  @override
  void initState() {
    super.initState();
    name = widget.item['name'];
    description = widget.item['description'];
    price = widget.item['price'];
  }

  Future<void> updateItem() async {
    final response = await http.put(
      Uri.parse('http://172.25.208.38:3000/items/${widget.item['id']}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'description': description, 'price': price}),
    );
    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      throw Exception('Failed to update item');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Item')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (value) {
                  name = value!;
                },
              ),
              TextFormField(
                initialValue: description,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  description = value!;
                },
              ),
              TextFormField(
                initialValue: price.toString(),
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  price = double.parse(value!);
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    updateItem();
                  }
                },
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
