import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:todolist/pages/adds.dart';
import 'package:todolist/pages/update_todolist.dart';

class Todolist extends StatefulWidget {
  const Todolist({Key? key}) : super(key: key);

  @override
  _TodolistState createState() => _TodolistState();
}

class _TodolistState extends State<Todolist> {
  List todolistitems = [];
  @override
  void initState() {
    super.initState();
    getTodolist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddPage()))
              .then((value) {
            setState(() {
              if ((value) == 'created') {
                // ignore: prefer_const_constructors
                final snackBar = SnackBar(
                  // ignore: prefer_const_constructors
                  content: Text('Created'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              getTodolist();
            });
          });
        },
        // ignore: prefer_const_constructors
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('All Todolist'),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  getTodolist();
                });
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: todolistCreate(),
    );
  }

  Widget todolistCreate() {
    return ListView.builder(
        itemCount: todolistitems.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text("${todolistitems[index]['title']}"),
              onTap: () {
                print('<<<<<<<<<${todolistitems[index]}>>>>>>>>>');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateTodolist(
                        todolistitems[index]['id'],
                        todolistitems[index]['title'],
                        todolistitems[index]['detail']),
                  ),
                ).then((value) {
                  setState(() {
                    print(value);
                    if (value == 'deleted') {
                      // ignore: prefer_const_constructors
                      final snackBar = SnackBar(
                        content: const Text('ลบรายการเรียบร้อยแล้ว'),
                      );

                      // Find the ScaffoldMessenger in the widget tree
                      // and use it to show a SnackBar.
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    getTodolist();
                  });
                });
              },
            ),
          );
        });
  }

  Future<void> getTodolist() async {
    var url = Uri.http('192.168.0.199:8000', '/api/all-todolist');
    var response = await http.get(url);
    var result = utf8.decode(response.bodyBytes);

    setState(() {
      print(todolistitems);
      todolistitems = jsonDecode(result);
    });
  }
}
