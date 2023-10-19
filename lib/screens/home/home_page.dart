import 'dart:convert';
import 'dart:js_interop';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hw/models/todo_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _dio = Dio(BaseOptions(responseType: ResponseType.plain));
  List<TodoItem>? _itemList;
  String? _error;

  void getTodos() async {
    try {
      setState(() {
        _error = null;
      });

      // await Future.delayed(const Duration(seconds: 3), () {});

      final response =
      await _dio.get('https://jsonplaceholder.typicode.com/albums');
      debugPrint(response.data.toString());
      // parse
      List list = jsonDecode(response.data.toString());
      setState(() {
        _itemList = list.map((item) => TodoItem.fromJson(item)).toList();
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      debugPrint('เกิดข้อผิดพลาด: ${e.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();
    getTodos();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (_error != null) {
      body = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_error!),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              getTodos();
            },
            child: const Text('RETRY'),
          )
        ],
      );
    } else if (_itemList == null) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      body = ListView.builder(

          itemCount: _itemList!.length,
          itemBuilder: (context, index) {
            var todoItem = _itemList![index];
            return Card(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      Row(children: [Text(todoItem.title)]),
                      Row(children: [Column(children:
                      [Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(decoration: BoxDecoration(border: Border.all(color: Colors.black,style: BorderStyle.solid),borderRadius: BorderRadius.circular(15.0),color: Colors.greenAccent),
                            padding: const EdgeInsets.all(3.0),child: Text("Albums Id "+todoItem.id.toString(),style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.normal))),
                      )],),
                      Column(children: [Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(decoration: BoxDecoration(border: Border.all(color: Colors.black,style: BorderStyle.solid),borderRadius: BorderRadius.circular(15.0),color: Colors.yellowAccent),
                            padding: const EdgeInsets.all(3.0),child: Text("User Id "+todoItem.userId.toString(),style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.normal))),
                      )],)],)
                      ],
                      )
                      
            )
            );
          });
    }

    return Scaffold(appBar: AppBar(title: Center(child: const Text('PhotoAlbums',))),body: body);
  }
}